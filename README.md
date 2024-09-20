# eventbridge-rule CfHighlander component
## Parameters

| Name | Use | Default | Global | Type | Allowed Values |
| ---- | --- | ------- | ------ | ---- | -------------- |
| EnvironmentName | Tagging | dev | true | string
| EnvironmentType | Tagging | development | true | string | ['development', 'production']
| EventsRuleState | Enable/Disable the EB rules | ENABLED | false | string | ['ENABLED', 'DISABLED']

## Outputs/Exports

| Name | Value | Exported |
| ---- | ----- | -------- |

## Included Components

## Example Configuration
### Highlander
```
  Component name: 'eventbridge-rule', template: 'eventbridge-rule'
```

## Cfhighlander Setup

install cfhighlander [gem](https://github.com/theonestack/cfhighlander)

```bash
gem install cfhighlander
```

or via docker

```bash
docker pull theonestack/cfhighlander
```
## Testing Components

1. [optional] Create new test files
- You could copy existing test file. When you do so, please change the file name and `test_metadata.name` according to the test file name
2. Run `cfhighlander cftest`
3. Run `kurgan test <test_file_name> --type spec` for each of the test files to re-generate the spec files
- Example `<test_file_name>`: hello-world for tests/hello-world.test.yaml
4. Run `rspec`
