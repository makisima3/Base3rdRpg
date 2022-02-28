using System;
using System.Collections;
using System.Collections.Generic;
using Core.Code.BuffSystem;
using Core.Code.BuffSystemImpls.Buffs;
using Core.Code.BuffSystemImpls.Stats;
using UnityEngine;
using UnityEngine.Serialization;

namespace Core.Code.BuffSystemImpls.Effects
{
    public class CriticalChanceBuffEffect : MonoBehaviour, IEffect<CriticalChanceBuff>
    {
        [SerializeField] private GameObject particles;

        public List<CriticalChanceBuff> ActiveBuffs { get; private set; }

        public void Activate(CriticalChanceBuff buff)
        {
            ActiveBuffs ??= new List<CriticalChanceBuff>();

            ActiveBuffs.Add(buff);
            
            particles.SetActive(true);
        }

        public void Deactivate(CriticalChanceBuff buff)
        {
            ActiveBuffs.Remove(buff);

            if (ActiveBuffs.Count <= 0)
            particles.SetActive(false);
        }
    }
}