echo "pullin latest ginger container"
docker pull ghcr.io/ginger-automation/gingerexecutionservice:latest

echo "running ginger container - registering to handler url: $EXECUTION_HANDLER_URL"
docker run ghcr.io/ginger-automation/gingerexecutionservice:latest --AgentConfigurations:HandlerURL=$EXECUTION_HANDLER_URL --AgentConfigurations:Name=DockerAgent1 --AgentConfigurations:TagName=DockerAgent --AgentConfigurations:ProcessesCapacity=2 --AgentConfigurations:DisableHandlerIpFilter=True