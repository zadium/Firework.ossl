/**
    @name: FireworkBall
    @description:

    @author:
    @version: 1.8
    @updated: "2022-11-15 14:51:17"
    @revision: 307
    @localfile: ?defaultpath\Firework\?@name.lsl
    @license: ?

    @ref:

    @notice:
*/

list StartColors = [
    <0.8,0.1,0.1>,
    <0.8,0.5,0.1>,
    <0.2,0.5,0.1>
    ];

list EndColors = [
    <0.9,0.2,0.3>,
    <0.9,0.9,0.3>,
    <0.3,0.6,0.3>
    ];

playsoundExplode()
{
    llPlaySound("Explode", 1.0);
}

playsoundWhistle()
{
    llPlaySound("Whistle", 1.0);
}

explode()
{
    integer index = ((integer)llGetObjectDesc()) % llGetListLength(StartColors);
    vector start_color = llList2Vector(StartColors, index);
    vector end_color = llList2Vector(EndColors, index);

    llSetLinkPrimitiveParams(LINK_THIS, [PRIM_POINT_LIGHT, TRUE, start_color, 1.0, 20, 0, PRIM_GLOW, ALL_SIDES, 1]);

    playsoundExplode();
    integer flags = 0;
    flags = flags | PSYS_PART_EMISSIVE_MASK | PSYS_PART_INTERP_COLOR_MASK;
//    flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
//    flags = flags | PSYS_PART_WIND_MASK;
//    flags = flags | PSYS_PART_BOUNCE_MASK;
    flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    list params = [
                    PSYS_SRC_MAX_AGE, 1,
                    PSYS_SRC_BURST_RADIUS, 0.1,
                    PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
                    PSYS_SRC_BURST_RATE, 0.1,
                    PSYS_SRC_ACCEL, <0 ,0 , -0.1>,
                    PSYS_SRC_BURST_PART_COUNT, 10,
                    PSYS_SRC_BURST_SPEED_MIN, 0.2,
                    PSYS_SRC_BURST_SPEED_MAX, 0.5,
                    PSYS_SRC_ANGLE_BEGIN, -PI/2,
                    PSYS_SRC_ANGLE_END, PI/2,
                    PSYS_SRC_OMEGA, <0,0,0>,

                    PSYS_PART_MAX_AGE, 3,
                    PSYS_PART_FLAGS, flags,
                    PSYS_PART_START_GLOW, 0.05,
                    PSYS_PART_END_GLOW, 0.01,
                    PSYS_PART_START_ALPHA, 0.9,
                    PSYS_PART_END_ALPHA, 0.01,
                    PSYS_PART_START_COLOR, start_color,
                    PSYS_PART_END_COLOR, end_color,
                    PSYS_PART_START_SCALE, <0.3,0.3,0.0>,
                    PSYS_PART_END_SCALE, <0.5,0.5,0.0>
    ];

    llParticleSystem(params);
}

integer stateBall = 0;

fireworkOn()
{
    if ((integer)llGetObjectDesc()>0)
        llSetStatus(STATUS_PHYSICS, FALSE);
    explode();
}

shoot()
{
    //tail(); //* no, save some for explode
    playsoundWhistle();
    stateBall = 0;
    llSetTimerEvent(2);
}

init()
{
	llParticleSystem([]);
	llSetLinkPrimitiveParams(LINK_THIS, [PRIM_POINT_LIGHT, TRUE, <1,1,1>, 0, 0, 0, PRIM_GLOW, ALL_SIDES, 0.5]);
}

default
{
    state_entry()
    {
        init();
        stateBall = 0;
    }

    on_rez(integer number)
    {
        llParticleSystem([]);
        if (number > 0) {
            llSetObjectDesc((string)number);
            llSetPrimitiveParams([PRIM_TEMP_ON_REZ, TRUE]);
            shoot();
        }
    }

    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            shoot();
        }
    }

    timer()
    {
        if (stateBall == 0)
        {
            stateBall = 1;
            llSetTimerEvent(2);
        }
        else if (stateBall == 1)
        {
            stateBall = 2;
            fireworkOn();
            llSetTimerEvent(1);
        }
        else
        {
            if ((integer)llGetObjectDesc()>0) //* not testing
                llDie();
            else
            	init();
        }
    }

}
