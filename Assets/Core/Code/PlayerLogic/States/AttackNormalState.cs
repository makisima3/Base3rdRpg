using System;
using Core.Code.BuffSystemImpls.Stats;
using Core.Code.BuffSystemImpls.Stats.Interfaces;
using Plugins.StateMachine;
using UnityEngine;

namespace Core.Code.PlayerLogic.States
{
    public class AttackNormalState : State<PlayerStateMachine.States>
    {
        [Serializable]
        private class AnimatorParameterNames
        {
            [SerializeField] private string isAttackNormal;
            [SerializeField] private string attackNormalSpeed;

            public string IsAttackNormal => isAttackNormal;
            public string AttackNormalSpeed => attackNormalSpeed;
        }

        [SerializeField] private AnimatorParameterNames animatorParameterNames;
        [SerializeField] private PlayerStats playerStats;
        [SerializeField] private Animator animator;

        public override PlayerStateMachine.States Type => PlayerStateMachine.States.AttackNormal;

        public override void OnEnter(PlayerStateMachine.States previousState)
        {
            animator.SetFloat(animatorParameterNames.AttackNormalSpeed, playerStats.AttackRate);
            
            animator.SetBool(animatorParameterNames.IsAttackNormal, true);
            playerStats.OnChanged.AddListener(OnAttackRateChanged);
        }

        public override void OnExit(PlayerStateMachine.States nextState)
        {
            animator.SetBool(animatorParameterNames.IsAttackNormal, false);
            playerStats.OnChanged.RemoveListener(OnAttackRateChanged);
        }

        public override void Loop()
        {
        }

        private void OnAttackRateChanged(IHasAttackRateStat stats) =>
            animator.SetFloat(animatorParameterNames.AttackNormalSpeed, stats.AttackRate);
    }
}