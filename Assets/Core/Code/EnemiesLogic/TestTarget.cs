using Core.Code.Models;
using UnityEngine;

namespace Core.Code.EnemiesLogic
{
    public class TestTarget : MonoBehaviour, ITarget
    {
        public void TakeDamage(Damage damage)
        {
            Debug.Log($"Damage = {damage.Amount}");
        }
    }
}