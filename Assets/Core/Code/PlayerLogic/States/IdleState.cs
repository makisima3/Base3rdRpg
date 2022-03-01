using System;
using Plugins.StateMachine;
using UnityEngine;

namespace Core.Code.PlayerLogic.States
{
    public class IdleState : State<PlayerStateMachine.States>
    {
        [SerializeField] private PlayerAttackController playerAttackController;
        
        public override PlayerStateMachine.States Type => PlayerStateMachine.States.Idle;
        public override void OnEnter(PlayerStateMachine.States previousState)
        {
           
        }

        public override void OnExit(PlayerStateMachine.States nextState)
        {
           
        }

        public override void Loop()
        {
            playerAttackController.TryStartAttack();
        }
    }
}