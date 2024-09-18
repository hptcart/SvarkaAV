
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

        if (Networking.IsOwner(gameObject))
            RequestSerialization();
    }
    public void hit()
    {
        if (!Networking.IsOwner(gameObject))
        {
            Networking.SetOwner(Networking.LocalPlayer, gameObject);
        }
        RequestSerialization();
        hitSync();
        Debug.Log(gameObject.name + " hit");

    }
    public override void OnDeserialization()
    {
        hitSync();

    }
    void hitSync()
    {
        //Debug.Log(gameObject.name+ " was hited by pickaxe");
        if (colddown < Time.fixedTime)
        {
            if (durability > 0)
            {
                durability--;
                colddown = CDTime + Time.fixedTime;
            }
        }
        
            
            
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
                    hardRockPull[i].SetActive(true);
                }
            }
            else
            {
                Debug.Log(gameObject.name + " has broken");
                anim.SetInteger(animName, 3);
                for (int i = 0; i < fullRockPull.Length; i++)
                {
                    fullRockPull[i].SetActive(true);
                }
            }
        
    }
}
