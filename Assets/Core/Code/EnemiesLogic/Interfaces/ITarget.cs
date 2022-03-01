using Core.Code.Models;

namespace Core.Code.EnemiesLogic
{
    public interface ITarget
    {
        void TakeDamage(Damage damage);
    }
}