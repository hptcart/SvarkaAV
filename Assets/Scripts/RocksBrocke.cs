
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class RocksBrocke : UdonSharpBehaviour
{
    public Animator anim;
    [UdonSynced] public int durability;
    public int medDamage;
    public int hardDamage;
    public int fullDamage;
    int brokeStage;

    public float CDTime;
    public float colddown;

    public void hit()
    {
        //Debug.Log(gameObject.name+ " was hited by pickaxe");
        if (durability > 0)
        {
            if (colddown < Time.fixedTime)
            {
                durability--;
                if (medDamage < durability)
                {
                    Debug.Log(gameObject.name + " no damage");
                }
                else if (hardDamage < durability && durability < medDamage)
                {
                    Debug.Log(gameObject.name + " have med damage");
                }
                else if (fullDamage < durability)
                {
                    Debug.Log(gameObject.name + " have hard damage");
                }
                else
                {
                    Debug.Log(gameObject.name + " has broken");
                }
            }
        }
        
    }
}
