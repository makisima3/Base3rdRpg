using UnityEngine;

namespace Core.Code.EnemiesLogic
{
    public class TestTarget : MonoBehaviour, ITarget
    {
        public void TakeDamage(float damage,bool isCritical)
        {
            Debug.Log($"Damage = {damage}");
        }
    }
}