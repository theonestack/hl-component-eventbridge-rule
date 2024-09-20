CloudFormation do  
    events = external_parameters.fetch(:events, {})
    events.each do |name, properties|
      event_pattern = {}
      schedule_pattern = ""

      # rule with event pattern or schedule
      case properties["type"]
      when "event_pattern"
        event_pattern = {
          source: properties["source"],
          "detail-type": properties["detail_type"],
          "detail": properties["detail"]
        }
      when "schedule"
        schedule_pattern = properties["schedule_pattern"]
      end

      # event targets
      targets = []
      properties['targets'].each do |target|
        event_target = {}

        event_target["Arn"] = FnSub(target["arn"])
        event_target["Id"] = FnSub("${EnvironmentName}-#{target["id"]}")
        event_target["Input"] = FnSub(target["input"].to_json) if target.has_key?('input')

        if target.has_key?('dlq_arn')
          event_target["DeadLetterConfig"] = {
            "Arn": FnSub(target["dlq_arn"])
          }
        end

        targets.append(event_target)
      end

      Events_Rule(name) do
        Description FnSub("${EnvironmentName}-#{name}")
        State Ref(:EventsRuleState)
        EventPattern FnSub(event_pattern.to_json) if properties["type"] == "event_pattern"
        ScheduleExpression schedule_pattern if properties["type"] == "schedule"
        Targets targets
      end

      # eventbridge permission resource depending on the target type
      properties['targets'].each do |target|
        case target["type"]
        when "lambda"
          Lambda_Permission("#{name}#{target["id"]}Permission") do
            FunctionName FnSub(target["arn"])
            Action 'lambda:InvokeFunction'
            Principal 'events.amazonaws.com'
            SourceArn FnGetAtt(name, "Arn")
          end
        end
      end

    end
  end
  