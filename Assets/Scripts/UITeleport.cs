
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using UnityEngine.UI;

public class UITeleport : UdonSharpBehaviour
{
    public GameObject target;
    public void ButtonPress()
    {
        Vector3 targetPosition = target.transform.position;
        Quaternion targetRotation = target.transform.rotation;
        if (Networking.LocalPlayer != null)
        {
            Networking.LocalPlayer.TeleportTo(targetPosition,
                                              targetRotation,
                                              VRC_SceneDescriptor.SpawnOrientation.Default,
                                              false);
        }
        else
        {

            Debug.Log("No have Local.Player");
        }
    } 
}
