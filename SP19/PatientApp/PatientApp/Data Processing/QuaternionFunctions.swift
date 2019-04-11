//
//  QuaternionFunctions.swift
//  PatientApp
//
//  Created by Darien Joso on 4/3/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import Foundation
import CoreGraphics

func create_quaternion(theta: Float, euler_axis: [Float]) -> [Float] {
    // creates a quaternion from an angle of rotation and a euler axis
    // normalize the euler axis
    var euler_array = euler_axis
    let norm3: Float = (euler_axis[0]*euler_axis[0]+euler_axis[1]*euler_axis[1]+euler_axis[2]*euler_axis[2]).squareRoot()
    euler_array[0] /= norm3
    euler_array[1] /= norm3
    euler_array[2] /= norm3
    // initialize new quaternion
    var q = [Float]()
    // populate new quaternion
    q.append( cos(0.5*theta) )
    q.append( sin(0.5*theta)*euler_array[0] )
    q.append( sin(0.5*theta)*euler_array[1] )
    q.append( sin(0.5*theta)*euler_array[2] )
    return q
}

func multiply(q1: [Float], q2: [Float]) -> [Float] {
    // multiplies two quaternions
    var q_out = [Float]()
    q_out.append( q1[0]*q2[0] - q1[1]*q2[1] - q1[2]*q2[2] - q1[3]*q2[3])
    q_out.append( q1[0]*q2[1] + q1[1]*q2[0] + q1[2]*q2[3] - q1[3]*q2[2])
    q_out.append( q1[0]*q2[2] - q1[1]*q2[3] + q1[2]*q2[0] + q1[3]*q2[1])
    q_out.append( q1[0]*q2[3] + q1[1]*q2[2] - q1[2]*q2[1] + q1[3]*q2[0])
    return q_out
}

func conjugate(q_in: [Float]) -> [Float] {
    // computes the conjugate of a quaternion
    let q_out = [ q_in[0], -q_in[1], -q_in[2], -q_in[3] ]
    return q_out
}

func norm(q_in: [Float]) -> Float {
    // computes the norm of the input quaternion
    let n: Float = ( q_in[0]*q_in[0] + q_in[1]*q_in[1] + q_in[2]*q_in[2] + q_in[3]*q_in[3] ).squareRoot()
    return n
}

func normalize(q_in: [Float]) -> [Float] {
    // normailizes the input quaternion
    let n = norm( q_in: q_in )
    let q_out = [ q_in[0]/n, q_in[1]/n, q_in[2]/n, q_in[3]/n ]
    return q_out
}

func inverse(q_in: [Float]) -> [Float] {
    // computes the inverse of the input quaternion
    let conj = conjugate( q_in: q_in )
    let n = norm( q_in: q_in )
    let q_out = [ conj[0]/(n*n), conj[1]/(n*n), conj[2]/(n*n), conj[3]/(n*n) ]
    return q_out
}

func rotated_vector(q_in: [Float], vector3: [Float]) -> [Float] {
    // rotates a vector using the input quaternion
    let vector4 = [ 0, vector3[0], vector3[1], vector3[2] ]
    let inv = inverse( q_in: q_in )
    let qi = multiply( q1: q_in, q2: vector4)
    let qj = multiply( q1: qi, q2: inv )
    let vector3_out = [ qj[1], qj[2], qj[3] ]
    return vector3_out
}

func get_theta(q_in: [Float]) -> Float {
    // computes the angle of rotation described by the input quaternion
    let n: Float = ( q_in[1]*q_in[1] + q_in[2]*q_in[2] + q_in[3]*q_in[3] ).squareRoot()
    // There might be a problem with this next line since atan2 takes CGFloats as input but I'm not positive
    let theta: Float = 2*atan2(n,q_in[0])
    return theta
}

func get_euler_axis(q_in: [Float]) -> [Float] {
    // computes the euler axis described by the input quaternion
    let n: Float = ( q_in[1]*q_in[1] + q_in[2]*q_in[2] + q_in[3]*q_in[3] ).squareRoot()
    let euler_axis = [ q_in[1]/n, q_in[2]/n, q_in[3]/n ]
    return euler_axis
}

//// quaternion to Euler angles

func get_roll(q: [Float]) -> Float {
    let num = 2 * (q[0] * q[1] + q[2] * q[3])
    let den = 1 - 2 * (q[1] * q[1] + q[2] * q[2])
    return atan2( num, den )
}

func get_pitch(q: [Float]) -> Float {
    return asin( 2 * (q[0] * q[2] - q[3] * q[1]) )
}

func get_yaw(q: [Float]) -> Float {
    let num = 2 * (q[0] * q[3] + q[1] * q[2])
    let den = 1 - 2 * (q[2] * q[2] + q[3] * q[3])
    return atan2( num, den )
}

// Struct
//struct Quaternion {
//    func quatMultiply(_ quat1: [Float], _ quat2: [Float]) -> [Float] {
//        // input: 2 quaternions (4 float array)
//        // output: 1 quaternion (4 float array)
//        var retQuat: [Float] = [0, 0, 0, 0]
//
//        if (quat1.count != 4 || quat2.count != 4) {
//            print("incorrect quaternion sizes")
//            return retQuat
//        }
//
//        retQuat[0] = quat1[0]*quat2[0] - quat1[1]*quat2[1] - quat1[2]*quat2[2] - quat1[3]*quat2[3]
//        retQuat[1] = quat1[0]*quat2[1] + quat1[1]*quat2[0] + quat1[2]*quat2[3] - quat1[3]*quat2[2]
//        retQuat[2] = quat1[0]*quat2[2] - quat1[1]*quat2[3] + quat1[2]*quat2[0] + quat1[3]*quat2[1]
//        retQuat[3] = quat1[0]*quat2[3] + quat1[1]*quat2[2] - quat1[2]*quat2[1] + quat1[3]*quat2[0]
//
//        return retQuat
//    }
//
//    func quatInverse(_ quat: [CGFloat]) -> [CGFloat] {
//        // input: 1 quaternion (4 CGFloat array)
//        // output: 1 quaternion (4 CGFloat array)
//        var retQuat: [CGFloat] = [0, 0, 0, 0]
//
//        if (quat.count != 4) {
//            print("incorrect quaternion size")
//            return retQuat
//        }
//
//        retQuat = [quat[0], -quat[1], -quat[2], -quat[3]]
//
//        return retQuat
//    }
//
//    func computeAngles (_ quat: [CGFloat]) -> [CGFloat] {
//        // input: quaternion (4 CGFloat array)
//        // output: roll/pitch/yaw array of (3 CGFloat array)
//        let roll = atan( (quat[0]*quat[1] + quat[2]*quat[3]) / (0.5 - quat[1]*quat[1] - quat[2]*quat[2]) )
//        let pitch = asin(-2.0*(quat[1]*quat[3] - quat[0]*quat[2]))
//        let yaw = atan( (quat[1]*quat[2] + quat[0]*quat[3]) / (0.5 - quat[2]*quat[2] - quat[3]*quat[3]) )
//
//        let rpy = [roll, pitch, yaw]
//
//        return rpy
//    }
//}

func create_quaternion(theta: Double, euler_axis: [Double]) -> [Double] {
    // creates a quaternion from an angle of rotation and a euler axis
    // normalize the euler axis
    var euler_array = euler_axis
    let norm3: Double = (euler_axis[0]*euler_axis[0]+euler_axis[1]*euler_axis[1]+euler_axis[2]*euler_axis[2]).squareRoot()
    euler_array[0] /= norm3
    euler_array[1] /= norm3
    euler_array[2] /= norm3
    // initialize new quaternion
    var q = [Double]()
    // populate new quaternion
    q.append( cos(0.5*theta) )
    q.append( sin(0.5*theta)*euler_array[0] )
    q.append( sin(0.5*theta)*euler_array[1] )
    q.append( sin(0.5*theta)*euler_array[2] )
    return q
}

func multiply(q1: [Double], q2: [Double]) -> [Double] {
    // multiplies two quaternions
    var q_out = [Double]()
    q_out.append( q1[0]*q2[0] - q1[1]*q2[1] - q1[2]*q2[2] - q1[3]*q2[3])
    q_out.append( q1[0]*q2[1] + q1[1]*q2[0] + q1[2]*q2[3] - q1[3]*q2[2])
    q_out.append( q1[0]*q2[2] - q1[1]*q2[3] + q1[2]*q2[0] + q1[3]*q2[1])
    q_out.append( q1[0]*q2[3] + q1[1]*q2[2] - q1[2]*q2[1] + q1[3]*q2[0])
    return q_out
}

func conjugate(q_in: [Double]) -> [Double] {
    // computes the conjugate of a quaternion
    let q_out: [Double] = [ q_in[0], -q_in[1], -q_in[2], -q_in[3] ]
    return q_out
}

func norm(q_in: [Double]) -> Double {
    // computes the norm of the input quaternion
    let n: Double = ( q_in[0]*q_in[0] + q_in[1]*q_in[1] + q_in[2]*q_in[2] + q_in[3]*q_in[3] ).squareRoot()
    return n
}

func normalize(q_in: [Double]) -> [Double] {
    // normailizes the input quaternion
    let n: Double = norm( q_in: q_in )
    let q_out: [Double] = [ q_in[0]/n, q_in[1]/n, q_in[2]/n, q_in[3]/n ]
    return q_out
}

func inverse(q_in: [Double]) -> [Double] {
    // computes the inverse of the input quaternion
    let conj: [Double] = conjugate( q_in: q_in )
    let n: Double = norm( q_in: q_in )
    let q_out: [Double] = [ conj[0]/(n*n), conj[1]/(n*n), conj[2]/(n*n), conj[3]/(n*n) ]
    return q_out
}

func rotated_vector(q_in: [Double], vector3: [Double]) -> [Double] {
    // rotates a vector using the input quaternion
    let vector4: [Double] = [ 0, vector3[0], vector3[1], vector3[2] ]
    let inv: [Double] = inverse( q_in: q_in )
    let qi: [Double] = multiply( q1: q_in, q2: vector4)
    let qj: [Double] = multiply( q1: qi, q2: inv )
    let vector3_out: [Double] = [ qj[1], qj[2], qj[3] ]
    return vector3_out
}

func get_theta(q_in: [Double]) -> Double {
    // computes the angle of rotation described by the input quaternion
    let n: Double = ( q_in[1]*q_in[1] + q_in[2]*q_in[2] + q_in[3]*q_in[3] ).squareRoot()
    // There might be a problem with this next line since atan2 takes CGFloats as input but I'm not positive
    let theta: Double = Double(2*atan2(n,q_in[0]))
    return theta
}

func get_euler_axis(q_in: [Double]) -> [Double] {
    // computes the euler axis described by the input quaternion
    let n: Double = ( q_in[1]*q_in[1] + q_in[2]*q_in[2] + q_in[3]*q_in[3] ).squareRoot()
    let euler_axis: [Double] = [ q_in[1]/n, q_in[2]/n, q_in[3]/n ]
    return euler_axis
}

// quaternion to Euler angles

func get_roll(q: [Double]) -> Double {
    let num = 2 * (q[0] * q[1] + q[2] * q[3])
    let den = 1 - 2 * (q[1] * q[1] + q[2] * q[2])
    return atan2( num, den )
}

func get_pitch(q: [Double]) -> Double {
    return asin( 2 * (q[0] * q[2] - q[3] * q[1]) )
}

func get_yaw(q: [Double]) -> Double {
    let num = 2 * (q[0] * q[3] + q[1] * q[2])
    let den = 1 - 2 * (q[2] * q[2] + q[3] * q[3])
    return atan2( num, den )
}
