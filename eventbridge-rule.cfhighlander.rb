CfhighlanderTemplate do
    Name 'eventbridge-rule'
    ComponentVersion component_version
    Description "#{component_name} - #{component_version}"
    
    Parameters do
      ComponentParam 'EnvironmentName', 'dev', isGlobal: true
      ComponentParam 'EnvironmentType', 'development', allowedValues: ['development','production'], isGlobal: true
      ComponentParam 'EventsRuleState', 'ENABLED', allowedValues: ['ENABLED', 'DISABLED']
    end
  
  end