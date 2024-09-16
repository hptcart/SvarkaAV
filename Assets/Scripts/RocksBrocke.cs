
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class RocksBrocke : UdonSharpBehaviour
{
    public Animator anim;
    public string animName;
    [UdonSynced] public int durability;
    public GameObject[] medRockPull;
    public GameObject[] hardRockPull;
    public GameObject[] fullRockPull;
    public int medDamage;
    public int hardDamage;
    public int fullDamage;
    int brokeStage;

    public float CDTime;
    float colddown;

    public void Start()
    {
        for(int i = 0; i<medRockPull.Length; i++)
        {
            medRockPull[i].SetActive(false);
        }
        for (int i = 0; i < hardRockPull.Length; i++)
        {
            hardRockPull[i].SetActive(false);
        }
        for (int i = 0; i < fullRockPull.Length; i++)
        {
            fullRockPull[i].SetActive(false);
        }
    }
    public void hit()
    {
        if (!Networking.IsOwner(gameObject))
        {
            Networking.SetOwner(Networking.LocalPlayer, gameObject);
        }
        RequestSerialization();
        hitSync();


    }
    public override void OnDeserialization()
    {
        hitSync();

    }
    void hitSync()
    {
        //Debug.Log(gameObject.name+ " was hited by pickaxe");
        if (durability > 0)
        {
            if (colddown < Time.fixedTime)
            {
                colddown = CDTime + Time.fixedTime;

                durability--;
                if (medDamage <= durability)
                {
                    Debug.Log(gameObject.name + " no damage");
                    anim.SetInteger(animName, 0);
                    
                }
                else if (hardDamage <= durability && durability < medDamage)
                {
                    Debug.Log(gameObject.name + " have med damage");
                    anim.SetInteger(animName, 1);
                    for (int i = 0; i < medRockPull.Length; i++)
                    {
                        medRockPull[i].SetActive(true);
                    }
                }
                else if (fullDamage <= durability && durability < hardDamage)
                {
                    Debug.Log(gameObject.name + " have hard damage");
                    anim.SetInteger(animName, 2);
                    for (int i = 0; i < hardRockPull.Length; i++)
                    {
                        hardRockPull[i].SetActive(false);
                    }
                }
                else
                {
                    Debug.Log(gameObject.name + " has broken");
                    anim.SetInteger(animName, 3);
                    for (int i = 0; i < fullRockPull.Length; i++)
                    {
                        fullRockPull[i].SetActive(false);
                    }
                }
            }
        }
    }
}
