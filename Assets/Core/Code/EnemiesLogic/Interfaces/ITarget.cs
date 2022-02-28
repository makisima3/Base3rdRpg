namespace Core.Code.EnemiesLogic
{
    public interface ITarget
    {
        void TakeDamage(float damage, bool isCritical);
    }
}