
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using VRC.Udon.Common;

public class Bellow : UdonSharpBehaviour
{
    public FuranceControl furance;
    public float bellowAdd;
    float addedPower;

    public float CDTime;
    public float colddown;
    public Animator bellowAnim;
    public string bellowPushUpAnim;

    public bool pressed;

    
    
    public override void OnPlayerTriggerEnter(VRCPlayerApi player)
    {
        if(!pressed) 
        { 
            if (colddown < Time.fixedTime)
            {
                if (!Networking.IsOwner(furance.gameObject))
                {
                    Networking.SetOwner(Networking.LocalPlayer, furance.gameObject);
                }


                colddown = CDTime + Time.fixedTime;
                SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, "BellowPushAnims");

                addedPower = furance.flamePowerAdded + bellowAdd;
                furance.flamePowerAdded = addedPower;
                furance.RequestSerialization();
            }
        }
        pressed = true;
    }
    public override void OnPlayerTriggerExit(VRCPlayerApi player)
    {
        
        pressed = false;
        
    }
    public void BellowPushAnims()
    {
        
        
        bellowAnim.SetTrigger(bellowPushUpAnim);
    }
}
