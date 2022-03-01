using System;
using Plugins.StateMachine;
using UnityEngine;

namespace Core.Code.PlayerLogic.States
{
    public class RunState : State<PlayerStateMachine.States>
    {
        [Serializable]
        private class AnimatorParameterNames
        {
            [SerializeField] private string isRun;
            [SerializeField] private string runBlend;

            public string IsRun => isRun;
            public string RunBlend => runBlend;
        }

        [SerializeField] private AnimatorParameterNames animatorParameterNames;
        [SerializeField] private Animator animator;
        [SerializeField] private Joystick joystick;
        [SerializeField] private PlayerMovementController playerMovementController;
        
        public override PlayerStateMachine.States Type => PlayerStateMachine.States.Run;
        
        public override void OnEnter(PlayerStateMachine.States previousState)
        {
            animator.SetBool(animatorParameterNames.IsRun, true);
            playerMovementController.StartMove();
        }

        public override void OnExit(PlayerStateMachine.States nextState)
        {
            //playerMovementController.StopMove();
            animator.SetBool(animatorParameterNames.IsRun, false);
        }

        public override void Loop()
        {
            var magnitude = joystick.Direction.magnitude;
            if(magnitude != 0f)
            {
                animator.SetFloat(animatorParameterNames.RunBlend, magnitude);
                playerMovementController.Move(joystick.Direction);
            }
            else
            {
                StateMachine.CurrentStateType = PlayerStateMachine.States.Idle;
            }
        }
    }
}