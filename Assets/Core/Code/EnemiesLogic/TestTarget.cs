using UnityEngine;

namespace Core.Code.EnemiesLogic
{
    public class TestTarget : ITarget
    {
        public void TakeDamage(float damage)
        {
            Debug.Log($"Damage = {damage}");
        }
    }
}