#pragma once

#include "Rendering/Renderer.h"
#include <vector>

class Physics
{
private:
	float m_Gravity;
	float m_GroundPosition;
	float m_GroundHeight;
	float m_GroundWidth;
	float m_BounceLevel;
	float m_AspectRatio;

public:
	Physics(float gravity, float groundPosition, float groundHeight, float groundWidth, float bounceLevel, float aspectRatio);
	~Physics();

	void Update(std::vector<Shape>& shapes);
	void SetGravity(float gravity);
	void SetBounceLevel(float bounceLevel);

private:
	void ApplyGravity(Shape& shape);
	void UpdatePosition(Shape& shape);
	void CheckGroundCollision(Shape& shape);
};