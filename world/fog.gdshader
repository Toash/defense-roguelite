shader_type canvas_item;

const float speed = 1.0;
const float amplitude = 1.0;

void vertex() {
    // add slight differences in frequency and phase
    float t = TIME * speed;

    VERTEX.x += sin(t) * amplitude;
    VERTEX.y += sin(t * 1.37 + 1.1) * amplitude; // different frequency & phase
}