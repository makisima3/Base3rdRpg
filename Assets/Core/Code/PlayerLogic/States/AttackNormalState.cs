﻿using Plugins.StateMachine;

namespace Core.Code.PlayerLogic.States
{
    public class AttackNormalState : State<PlayerStateMachine.States>
    {
        public override PlayerStateMachine.States Type => PlayerStateMachine.States.AttackNormal;
        public override void OnEnter(PlayerStateMachine.States previousState)
        {
            throw new System.NotImplementedException();
        }

        public override void OnExit(PlayerStateMachine.States nextState)
        {
            throw new System.NotImplementedException();
        }

        public override void Loop()
        {
            throw new System.NotImplementedException();
        }
    }
}