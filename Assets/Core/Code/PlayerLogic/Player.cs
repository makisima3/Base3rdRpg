using System;
using Core.Code.BuffSystemImpls;
using UnityEngine;

namespace Core.Code.PlayerLogic
{
    public class Player : MonoBehaviour
    {
        [SerializeField] private PlayerMovementController playerMovementController;
        [SerializeField] private PlayerAttackController playerAttackController;
        [SerializeField] private PlayerBuffController buffController;

        private void Awake()
        {
            playerAttackController.Init();
            playerMovementController.Init();
            buffController.Initialize();
        }
    }
}