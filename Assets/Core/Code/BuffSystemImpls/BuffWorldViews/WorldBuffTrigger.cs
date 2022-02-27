using Core.Code.BuffSystem;
using UnityEngine;

namespace Core.Code.BuffSystemImpls.BuffWorldViews
{
    [RequireComponent(typeof(Collider))]
    public abstract class WorldBuffTrigger<TStats, TBuff>: MonoBehaviour
        where TStats: IStats
        where TBuff : IBuff<TStats>
    {
        [SerializeField] private TBuff buff;
        
        private void OnTriggerEnter(Collider other)
        {
            if (other.TryGetComponent(out BuffController<TStats> controller))
            {
                controller.Apply(buff);
            }
        }
    }
}