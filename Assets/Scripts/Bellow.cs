
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class Bellow : UdonSharpBehaviour
{
    public FuranceControl furance;
    public float bellowAdd;
    float addedPower;

    public float CDTime;
    public float colddown;
    public Animator bellowAnim;
    public string bellowPushUpAnim;
    

    public override void Interact()
    {
        if (colddown < Time.fixedTime) {
            colddown = CDTime + Time.fixedTime;
            SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, "BellowPush");
        }
        
    }
    public void BellowPush()
    {
        addedPower = furance.flamePowerAdded + bellowAdd;
        furance.flamePowerAdded = addedPower;
        
        bellowAnim.SetTrigger(bellowPushUpAnim);
    }
}
