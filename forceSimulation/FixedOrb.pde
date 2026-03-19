class FixedOrb extends Orb
{

  /**
   A constructor for FixedOrb that lets you edit its position, size, and mass.
   */
  FixedOrb(float x, float y, float s, float m)
  {
    super(x, y, s, m);
    c = color(255, 0, 0);
  }

  /**
   A default constructor for FixedOrb
   */
  FixedOrb()
  {
    super();
    c = color(255, 0, 0);
  }

  /**
   The FixedOrb does not move, so its move function is replaced with nothing.
   */
  void move(boolean bounce)
  {
    //do nothing
  }
}//fixedOrb
