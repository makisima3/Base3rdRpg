using Plugins.StateMachine;

namespace Core.Code.PlayerLogic.States
{
    public class DeathState : State<PlayerStateMachine.States>
    {
        public override PlayerStateMachine.States Type => PlayerStateMachine.States.Death;
        
        public override void OnEnter(PlayerStateMachine.States previousState)
        {
           
        }

        public override void OnExit(PlayerStateMachine.States nextState)
        {
           
        }

        public override void Loop()
        {
            
        }
    }
}