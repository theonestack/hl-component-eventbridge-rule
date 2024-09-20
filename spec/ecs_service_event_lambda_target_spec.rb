require 'yaml'

describe 'compiled component eventbridge-rule' do
  
  context 'cftest' do
    it 'compiles test' do
      expect(system("cfhighlander cftest #{@validate} --tests tests/ecs_service_event_lambda_target.test.yaml")).to be_truthy
    end      
  end
  
  let(:template) { YAML.load_file("#{File.dirname(__FILE__)}/../out/tests/ecs_service_event_lambda_target/eventbridge-rule.compiled.yaml") }
  
  context "Resource" do

    
    context "TestEvent" do
      let(:resource) { template["Resources"]["TestEvent"] }

      it "is of type AWS::Events::Rule" do
          expect(resource["Type"]).to eq("AWS::Events::Rule")
      end
      
      it "to have property Description" do
          expect(resource["Properties"]["Description"]).to eq({"Fn::Sub"=>"${EnvironmentName}-TestEvent"})
      end
      
      it "to have property State" do
          expect(resource["Properties"]["State"]).to eq({"Ref"=>"EventsRuleState"})
      end
      
      it "to have property EventPattern" do
          expect(resource["Properties"]["EventPattern"]).to eq({"Fn::Sub"=>"{\"source\":[\"aws.ecs\"],\"detail-type\":[\"ECS Task State Change\"],\"detail\":{\"lastStatus\":[\"RUNNING\"],\"desiredStatus\":[\"RUNNING\"],\"clusterArn\":[\"arn:aws:ecs:ap-southeast-2:123456789012:cluster/cluster1\"],\"group\":[\"service:nginx\"]}}"})
      end
      
      it "to have property Targets" do
          expect(resource["Properties"]["Targets"]).to eq([{"Arn"=>"arn:aws:lambda:ap-southeast-2:123456789012:function:hello-world", "Id"=>{"Fn::Sub"=>"${EnvironmentName}-HelloWorldLambda"}, "Input"=>{"Fn::Sub"=>"{\"target_recycle_cluster_arn\":\"arn:aws:ecs:ap-southeast-2:123456789012:cluster/cluster1\",\"target_recycle_service_name\":\"nginx\",\"target_recycle_service_warmup_period_second\":0}"}, "DeadLetterConfig"=>{"Arn"=>"arn:aws:sqs:ap-southeast-2:123456789012:dlq"}}])
      end
      
    end
    
    context "TestEventHelloWorldLambdaPermission" do
      let(:resource) { template["Resources"]["TestEventHelloWorldLambdaPermission"] }

      it "is of type AWS::Lambda::Permission" do
          expect(resource["Type"]).to eq("AWS::Lambda::Permission")
      end
      
      it "to have property FunctionName" do
          expect(resource["Properties"]["FunctionName"]).to eq("arn:aws:lambda:ap-southeast-2:123456789012:function:hello-world")
      end
      
      it "to have property Action" do
          expect(resource["Properties"]["Action"]).to eq("lambda:InvokeFunction")
      end
      
      it "to have property Principal" do
          expect(resource["Properties"]["Principal"]).to eq("events.amazonaws.com")
      end
      
      it "to have property SourceArn" do
          expect(resource["Properties"]["SourceArn"]).to eq({"Fn::GetAtt"=>["TestEvent", "Arn"]})
      end
      
    end
    
  end

end