using System.CommandLine;

namespace QueueTool;

internal class ProduceCommand : Command
{
    public ProduceCommand() : base("produce", "Fill the queue with multiple items")
    {
        Add(CommandOptions.MessageCount);
    }
}