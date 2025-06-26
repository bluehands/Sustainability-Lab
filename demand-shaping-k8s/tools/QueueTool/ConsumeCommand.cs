using System.CommandLine;

namespace QueueTool;

internal class ConsumeCommand : Command
{
    public ConsumeCommand() : base("consume", "Continuously consume items from the queue")
    {
        Add(CommandOptions.WaitTimer);
    }
}