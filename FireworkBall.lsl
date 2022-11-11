/**
    @name: FireworkBall
    @description:

    @author:
    @version: 1.1
    @updated: "2022-11-11 00:23:59"
    @revision: 278
    @localfile: ?defaultpath\Firework\?@name.lsl
    @license: ?

    @ref:

    @notice:
*/

float particleLife = 2.0;

list StartColors = [
    <0.8,0.2,0.1>,
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

tail()
{
    llParticleSystem([
        PSYS_PART_FLAGS,
            PSYS_PART_INTERP_COLOR_MASK
            | PSYS_PART_INTERP_SCALE_MASK
            | PSYS_PART_EMISSIVE_MASK
//            | PSYS_PART_FOLLOW_VELOCITY_MASK
//            | PSYS_PART_BOUNCE_MASK
//            | PSYS_PART_FOLLOW_SRC_MASK
        ,
        PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
        PSYS_SRC_BURST_RADIUS,      0.01,
        PSYS_SRC_BURST_RATE,        0.1,
        PSYS_SRC_ANGLE_BEGIN,       -PI/4,
        PSYS_SRC_ANGLE_END,         PI/4,
        PSYS_SRC_BURST_PART_COUNT,  25,
        PSYS_SRC_BURST_SPEED_MIN,   0.01,
        PSYS_SRC_BURST_SPEED_MAX,   0.05,
        PSYS_SRC_ACCEL,             <0.0, 0.0, 0.0>,
        PSYS_SRC_OMEGA,             <0.0, 0.0, 0.0>,

        PSYS_PART_START_COLOR,      <0.9, 0.9, 0.9 >,
        PSYS_PART_END_COLOR,        <1, 1, 1>,
        PSYS_PART_START_GLOW,       0.0,
        PSYS_PART_END_GLOW,         0.01,
        PSYS_PART_START_ALPHA,      0.5,
        PSYS_PART_END_ALPHA,        0.9,
        PSYS_PART_START_SCALE,      <0.03, 0.03, 0.03>,
        PSYS_PART_END_SCALE,        <0.07, 0.07, 0.07>,
        PSYS_PART_MAX_AGE,          2
        ]);
}

fireworkTo(key target)
{
    integer index = ((integer)llGetObjectDesc()) % llGetListLength(StartColors);
    vector start_color = llList2Vector(StartColors, index);
    vector end_color = llList2Vector(EndColors, index);

    playsoundExplode();
    integer flags = 0;
    flags = flags | PSYS_PART_EMISSIVE_MASK | PSYS_PART_INTERP_COLOR_MASK;
//    flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
//    flags = flags | PSYS_PART_WIND_MASK;
//    flags = flags | PSYS_PART_BOUNCE_MASK;
    flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if ((target != "") && (target != NULL_KEY))
        flags = flags | PSYS_PART_TARGET_POS_MASK;
    list params = [ PSYS_SRC_MAX_AGE, particleLife,
                    PSYS_SRC_TARGET_KEY, target,
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

                    PSYS_PART_MAX_AGE, 10,
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
    llSetStatus(STATUS_PHYSICS, FALSE);
    fireworkTo("");
}

shoot()
{
    stateBall = 0;
    //tail(); //* no, save sime for explode
    playsoundWhistle();
}

default
{
    state_entry()
    {
        llParticleSystem([]);
        stateBall = 0;
    }

    on_rez(integer number)
    {
        llParticleSystem([]);
        if (number > 0) {
            llSetObjectDesc((string)number);
            llSetPrimitiveParams([PRIM_TEMP_ON_REZ, TRUE]);
            shoot();
            llSetTimerEvent(2);
        }
    }

    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            shoot();
            llSleep(2);
            fireworkOn();
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
            if ((integer)llGetObjectDesc()>0)
                llDie();
        }
    }

}
