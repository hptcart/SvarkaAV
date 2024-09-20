
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class Pickaxe : UdonSharpBehaviour
{
    public ParticleSystem parSys;
    public GameObject[] rocks;
    public float hitSpeed;
    public override void OnPickupUseDown()
    {
        //parSys.Play();
    }
    void OnCollisionEnter(Collision collision)
    {
        if (gameObject.GetComponent<VRC_Pickup>().IsHeld)
        { 
            if (collision.relativeVelocity.magnitude > hitSpeed)
            {
                for(int i = 0; i < rocks.Length; i++)
                {
                    if(collision.gameObject.GetComponent<RocksBrocke>()!=null)
                    {
                        SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, "Sparks");
                        //Debug.Log("pickaxe did hit");
                        collision.gameObject.GetComponent<RocksBrocke>().hit();
                    }
                }
            
            }
        }
        //Debug.Log(collision.relativeVelocity.magnitude+ " hit velocity;");
        //Debug.Log(collision.gameObject.name);

    }
    
    public void Sparks()
    {
        parSys.Play();
    }
    
}
