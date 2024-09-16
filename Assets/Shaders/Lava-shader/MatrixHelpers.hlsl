#ifndef MATRIX_HELPERS_INCLUDED
#define MATRIX_HELPERS_INCLUDED

float2x2 GetRotationMatrix2D(float angle)
{
	return float2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
}

float2x2 GetScaleMatrix2D(float scale)
{
	return float2x2(scale, 0, 0, scale);
}

float4 EulerToQuaternion(float3 angle)
{
	float cy = cos(angle.z * 0.5);
	float sy = sin(angle.z * 0.5);
	float cp = cos(angle.y * 0.5);
	float sp = sin(angle.y * 0.5);
	float cr = cos(angle.x * 0.5);
	float sr = sin(angle.x * 0.5);

	float4 q;
	q.w = cy * cp * cr + sy * sp * sr;
	q.x = cy * cp * sr - sy * sp * cr;
	q.y = sy * cp * sr + cy * sp * cr;
	q.z = sy * cp * cr - cy * sp * sr;
	return q;
}

float4 EulerToAxisAngle(float3 angles, bool normalize)
{
	// Assuming the angles are in radians.
	float3 axis, c, s;
	sincos(angles / 2, s, c);
	axis.x = c.y * c.z * s.x + c.x * s.y * s.z;
	axis.y = c.z * c.x * s.y + c.y * s.x * s.z;
	axis.z = c.x * c.y * s.z - c.z * s.x * s.y;
	float angle = 2 * acos(c.x * c.y * c.z - s.x * s.y * s.z);
	if (normalize)
	{
		float norm = dot(axis, axis);
		if (norm < 1e-6)
		{
			// when all euler angles are zero angle = 0 so
			// we can set axis to anything to avoid divide by zero
			axis = float3(0, 0, 1);
		}
		else
		{
			axis /= sqrt(norm);
		}
	}
	return float4(axis, angle);
}

float3x3 AxisAngleRotationMatrix(float3 v, float angle)
{
	float C = cos(angle);
	float S = sin(angle);
	float t = 1 - C;
	float m00 = t * v.x * v.x + C;
	float m01 = t * v.x * v.y - S * v.z;
	float m02 = t * v.x * v.z + S * v.y;
	float m10 = t * v.x * v.y + S * v.z;
	float m11 = t * v.y * v.y + C;
	float m12 = t * v.y * v.z - S * v.x;
	float m20 = t * v.x * v.z - S * v.y;
	float m21 = t * v.y * v.z + S * v.x;
	float m22 = t * v.z * v.z + C;
	return float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
}

float4x4 GetTRS(float3 position, float3 rotation, float3 scale)
{
	float4x4 TS;
	float3 s, c;
	sincos(rotation, s, c);

	TS[0] = float4(scale.x, 0,       0,       position.x);
	TS[1] = float4(0,       scale.y, 0,       position.y);
	TS[2] = float4(0,       0,       scale.z, position.z);
	TS[3] = float4(0,       0,       0,                1);

	float3 a = rotation;
	float4x4 Ry;
	Ry[0] = float4( c.y, 0, s.y, 0);
	Ry[1] = float4( 0,   1, 0,   0);
	Ry[2] = float4(-s.y, 0, c.y, 0);
	Ry[3] = float4( 0,   0, 0,   1);

	float4x4 Rx;
	Rx[0] = float4(1, 0,    0,   0);
	Rx[1] = float4(0, c.x, -s.x, 0);
	Rx[2] = float4(0, s.x,  c.x, 0);
	Rx[3] = float4(0, 0,    0,   1);

	float4x4 Rz;
	Rz[0] = float4(c.z, -s.z, 0, 0);
	Rz[1] = float4(s.z,  c.z, 0, 0);
	Rz[2] = float4(0,    0,   1, 0);
	Rz[3] = float4(0,    0,   0, 1);

	float4x4 TRS;
	TRS = mul(TS,  Ry);
	TRS = mul(TRS, Rx);
	TRS = mul(TRS, Rz);
	return TRS;
}
#endif