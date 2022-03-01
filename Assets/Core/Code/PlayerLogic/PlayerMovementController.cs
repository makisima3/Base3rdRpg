using System;
using System.Collections;
using Core.Code.BuffSystem;
using Core.Code.BuffSystemImpls.Stats;
using DG.Tweening;
using UnityEditor;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

namespace Core.Code.PlayerLogic
{
    [RequireComponent(typeof(CharacterController))]
    public class PlayerMovementController : MonoBehaviour
    {
        [SerializeField] private Joystick joystick;
        [SerializeField] private PlayerStats playerStats;
        [SerializeField] private PlayerStateMachine playerStateMachine;
        
        [Space]
        [SerializeField] private AnimationCurve movingCurve;
        [SerializeField] private float speedIncreaseDuration = 1f;
        [SerializeField] private float speedDecreaseDuration = 0.2f;

        private CharacterController _characterController;
        private float _movingCurvePosition;
        private float _currentSpeed;
        private Tween _movingSpeedTween;

        public bool IsMoving => joystick.Direction.sqrMagnitude < Mathf.Epsilon;

        public void Init()
        {
            _characterController = GetComponent<CharacterController>();
        }

        private void Update()
        {
            if (joystick.Direction.sqrMagnitude != 0f)
            {
                playerStateMachine.CurrentStateType = PlayerStateMachine.States.Run;
            }
        }

        public void StartMove()
        {
            DoSpeedTween(speedIncreaseDuration, true);
        }

        public void StopMove()
        {
            DoSpeedTween(speedDecreaseDuration, false);
        }

        public void Move(Vector3 direction)
        {
            direction = direction.normalized;

            direction.z = direction.y;
            direction.y = 0f;
            
            _characterController.Move(direction * _currentSpeed * Time.deltaTime);
        }

        private void DoSpeedTween(float duration, bool increase)
        {
            if (_movingSpeedTween != null)
            {
                _movingSpeedTween.Kill();
            }

            var endValue = increase ? 1f : 0f;
            _movingCurvePosition = 1f - endValue;
            _movingSpeedTween = DOTween.To(MovingSpeedTweenGetter, MovingSpeedTweenSetter, endValue, duration);
        }

        private float MovingSpeedTweenGetter() => _movingCurvePosition;

        private void MovingSpeedTweenSetter(float movingCurvePosition)
        {
            _movingCurvePosition = movingCurvePosition;
            _currentSpeed = playerStats.Speed * movingCurve.Evaluate(_movingCurvePosition);
        }
    }
}