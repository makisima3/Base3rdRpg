using Plugins.StateMachine;
using UnityEngine;

namespace Core.Code.PlayerLogic
{
    
    public class PlayerStateMachine : StateMachine<PlayerStateMachine.States>
    {
        public enum States
        {
            Idle,
            AttackNormal,
            Run,
            Death,
        }
        
        
    }
}