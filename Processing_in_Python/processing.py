# Notes:
# Useful data to display:
#   Maximum range for a session
#   Number of reps in a session
#   Average range over all the reps
# Find a way to measure exercise form


file = open("data.txt", 'r')
data = file.readlines()
file2 = open("ex.txt", 'w')

# x, y, and z angles from the shoulder IMU
x_0 = []
y_0 = []
z_0 = []

# x, y, and z angles from the upper-arm IMU
x_1 = []
y_1 = []
z_1 = []

# x, y, and z angles from the lower-arm IMU
x_2 = []
y_2 = []
z_2 = []

# put IMU angles into lists
for line in data:
    xyz = line.split()
    x_0 += [float(xyz[0])]
    y_0 += [float(xyz[1])]
    z_0 += [float(xyz[2])]
    x_1 += [float(xyz[0])]
    y_1 += [float(xyz[1])]
    z_1 += [float(xyz[2])]
    x_2 += [float(xyz[0])]
    y_2 += [float(xyz[1])]
    z_2 += [float(xyz[2])]

for ang in x_0:
    file2.write(str(ang)+"\n")

def getMaxX(x):
    max_x_ind = absx.index(max(x, key=abs))
    y_max_x = y[max_x_ind]
    z_max_x = z[max_x_ind]
    x = max(x, key=abs)
    return [x,y_max_x,z_max_x]

# returns the maximum angle in a list of angles
def get_max_angle(x):
    max_x = max(x, key=abs)
    return max_x

# splits the x, y, and z lists for a given IMU into reps
# xyz is a list [x,y,z] of xyz lists
# the index (0-2) specifies whether x, y, or z is the most useful list to
# analyze to observe the repetitions
def splitReps(xyz, ind):
    # obtain the relevant list for analyzing reps
    main_list = xyz[ind]
    # initialize useful variables and lists
    ang_prev = 0
    count = 0
    current_rep = []
    reps = []
    # go through all the angles and separate into reps
    for ang in main_list:
        if abs(ang) >= abs(ang_prev):
            current_rep += [ang]
            count = 0
        else:
            count += 1
            current_rep += [ang]
            if count == 20:
                if len(current_rep) > 200:
                    reps += [current_rep]
                current_rep = []
                count = 0
        ang_prev = ang
    return reps


# Front Arm Raises (Shoulder Flexion)
# x-axis motion (around the x-axis) for IMU 1 and IMU 2 (forearm and upper arm should be aligned for this exercise)
# There should be very minimal movement for IMU 0
def front_arm_raises():
    # get number of reps of exercise
    reps = splitReps([x_0, x_1, x_2], 1)
    # go through the reps to find the average max angle
    max_angs = []
    for rep in reps:
        max_angs += [abs(max(rep, key=abs))]
    avg_max_angle = sum(max_angs) / len(max_angs)

    # sum up data in a table
    data = {"exercise": "front arm raises",
            "maximum angle": abs(get_max_angle(x_1)),
            "average maximum angle": avg_max_angle,
            "number of reps": len(reps)
            }
    return data

# Side Arm Raises (Shoulder Abduction)
# IMU 1 and IMU 2 rotation around the z-axis when arms are raised and slight rotation around the y axis to allow palms to face the front
# IMU 0 should not have significant rotation (however, if there is significant rotation on the y axis then it might be a sign of overcompensation)
def side_arm_raises():
    # should we have an if statement to ensure that x1 and x2 are the same ?

    # get number of reps of exercise
    reps = splitReps([z_0, z_1, z_2], 1)
    # go through the reps to find the average max angle
    max_angs = []
    for rep in reps:
        max_angs += [abs(max(rep, key=abs))]
    avg_max_angle = sum(max_angs) / len(max_angs)

    # sum up data in a table
    data = {"exercise": "side arm raises",
            "maximum angle": abs(get_max_angle(x_1)),
            "average maximum angle": avg_max_angle,
            "number of reps": len(reps)
            }
    return data

# Shoulder Shrugs (Shoulder Elevation)
# Slight rotation on the z axis because the shoulders are changing orientation
def shoulder_shrugs():
    # get number of reps of exercise
    reps = splitReps([z_0, z_1, z_2], 0)

    return get_max_angle(z_0)

# Pumping (Elbow Flexion and Extension)
# Here we should have different motions for IMU 1 (upper arm) and IMU 2 (forearm)
# IMU 2 should be experiencing rotation from the y axis first and then large rotation on x axis
# IMU 1 and IMU 0 should not be changing
def pumping():

    # I added an if statement in order to make sure that the patients don't be moving
    # their upper arm during the pumping exercise and that their palms face up in the beginning

    if (get_max_angle(y_2) >= 60 and get_max_angle(x_1) <= 20):
        return get_max_angle(x_2)
    else:
        return 0 # didn't  know what exactly to return if the if statement failed

# Rotation of Arm (internal and external rotation)
# Rotation around the y axis - primarily on IMU2
def arm_rotation():
    # get number of reps of exercise
    reps = splitReps([y_0, y_1, y_2], 2)

    return get_max_angle(y_2)

# Shoulder Blade Pinch (Shoulder Retraction)
# No rotation on IMU 1 and IMU 2 but there should be rotation in the y axis on IMU 0 (this is the IMU that will be placed on top of the shoulder area
def shoulder_blade_pinch():
    return get_max_angle(y_0)


# Hand hold ( Shoulder Flexion)
# Rotation along the x axis only for IMU 1 and IMU 2 (need for recalibration because the patient will be on their back)
def hand_hold():
    # how will we take into account that we are on the ground? Should we have a 90 offset?
    return

# Butterfly (Horizontal Abduction and Adduction)
# Y axis for both imus
def butterfly():
    return

# Snow Angels (Shoulder Abduction)
# Rotation around the z direction for IMU 1 and IMU 2 and y direction for IMU 1(arm turns as you do snow angels)
def snow_angels():
    return

# Shoulder Crawl (Shoulder Flexion and Rotation)
# The starting position readings might be close to 90 maybe??
# The readings should be close to 180 because the axis will be flipped during this exercise
# IMU 0 should also have a small rotation in the x axis
def shoulder_crawl():
    return

# Forward Wall Crawl ( Shoulder Flexion)
# x-axis motion (similar to front arm raises but the angle values should be much larger)
def forward_wall_crawl():
    return

# Side Wall Crawl ( Shoulder Abduction)
# Z-axis rotation (also similar to the side arm raises but the angle values should be bigger than 90
def side_wall_crawl():
    return
