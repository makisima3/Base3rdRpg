using Core.Code.BuffSystem;

namespace Core.Code.BuffSystemImpls.Stats
{
    public interface IHasDamageStat : IStats
    {
        float Damage { get; set; }
        float BaseDamage { get; }
    }
}