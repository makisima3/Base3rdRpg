using System;
using System.Collections;
using Core.Code.BuffSystem;
using Core.Code.BuffSystemImpls.Stats;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

namespace Core.Code.PlayerLogic
{
    [RequireComponent(typeof(CharacterController))]
    public class PlayerMovementController : MonoBehaviour
    {
        [SerializeField] private FloatingJoystick joystick;
        [SerializeField] private PlayerStats playerStats;
        
        [SerializeField] private float dashForce = 3f;
        [SerializeField] private float speedSmooth = 0.1f;
        [SerializeField, Range(0f, 1f)] private float dashEdge = 0.7f;

        private bool _isDashReady = true;
        private Coroutine _dashReload;
        private float time;
        private float currentSpeed;
        private float targetSpeed;

        private CharacterController _characterController;
        private float _prevDirectionMagnitude;

        public bool IsMoving { get; private set; }
        
        public void Init()
        {
            _characterController = GetComponent<CharacterController>();
            _prevDirectionMagnitude = 0f;
            currentSpeed = 0;
        }

        private void Update()
        {
            IsMoving = !(joystick.Direction.magnitude < Mathf.Epsilon);

            targetSpeed = joystick.Direction.magnitude * playerStats.Speed;
                
            if (Mathf.Abs(joystick.Direction.magnitude - _prevDirectionMagnitude) > dashEdge)
            {
                targetSpeed += dashForce;
            }

            _prevDirectionMagnitude = joystick.Direction.magnitude;

            currentSpeed = Mathf.Lerp(currentSpeed, targetSpeed, speedSmooth);
            
            Move(joystick.Direction * currentSpeed * Time.deltaTime);
        }

        private void Move(Vector3 direction)
        {
            var dir = new Vector3()
            {
                x = direction.x,
                y = 0f,
                z = direction.y
            };

            _characterController.Move(dir);
        }

    }
}