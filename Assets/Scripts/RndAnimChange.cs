
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class RndAnimChange : UdonSharpBehaviour
{
    public float rndChance;
    public Animator animator;
    public string animName1;

    public void EndAnimation()
    {
        //Debug.Log(Random.value+" random test") ;
        if (Random.value < rndChance)
        {
            animator.SetTrigger(animName1);
        }
    }
}
