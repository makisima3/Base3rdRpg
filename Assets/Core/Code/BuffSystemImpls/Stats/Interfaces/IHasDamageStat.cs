using Core.Code.BuffSystem;

namespace Core.Code.BuffSystemImpls.Stats.Interfaces
{
    public interface IHasDamageStat : IStats
    {
        float Damage { get; set; }
        float BaseDamage { get; }
    }
}