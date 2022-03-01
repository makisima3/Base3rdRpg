using Plugins.AnimationEventHandling;
using UnityEngine;

namespace Core.Code.PlayerLogic
{
    public class PlayerAnimationEvents : AnimationEventsBase
    {
        [SerializeField] private PlayerAttackController playerAttackController;
        
        [AnimationEventHandler("AttackEvent")]
        private void AttackEventHandler()
        {
            playerAttackController.Attack();
        }
    }
}