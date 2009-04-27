package kernel;

import rescuecore2.worldmodel.WorldModel;
import rescuecore2.connection.ConnectionManagerListener;

/**
   This class manages connections from agents, including assigning which Robocup Rescue object each agent controls, and passing messages between the kernel and the agents.
 */
public interface AgentManager extends ConnectionManagerListener {
    /**
       Wait until all agents have connected.
    */
    public void waitForAllAgents() throws InterruptedException;
}