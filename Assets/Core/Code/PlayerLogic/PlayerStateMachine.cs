using Core.Code.PlayerLogic.States;
using Plugins.StateMachine;
using UnityEngine;

namespace Core.Code.PlayerLogic
{
    [RequireComponent(typeof(IdleState))]
    [RequireComponent(typeof(AttackNormalState))]
    [RequireComponent(typeof(RunState))]
    [RequireComponent(typeof(DeathState))]
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