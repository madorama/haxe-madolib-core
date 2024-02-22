package madolib.collider;

import differ.Collision;
import differ.data.RayCollision;
import differ.math.Vector;
import differ.shapes.Polygon;
import hxmath.math.Vector2;
import madolib.Option;
import madolib.geom.Bounds;

using madolib.extensions.DifferExt;

@:structInit
class HitPosition {
    public final start: Vector2;
    public final end: Option<Vector2>;

    public inline function new(start: Vector2, end: Option<Vector2>) {
        this.start = start;
        this.end = end;
    }
}

typedef Rect = {
    x: Float,
    y: Float,
    width: Float,
    height: Float,
    rotation: Float,
}

class Collide {
    public inline static function rayVsRay(a1: Vector2, a2: Vector2, b1: Vector2, b2: Vector2): Bool {
        final aRay = a1.createRayFromVector(a2);
        final bRay = b1.createRayFromVector(b2);
        final test = Collision.rayWithRay(aRay, bRay);
        return test != null;
    }

    public inline static function circleVsLine(pos: Vector2, radius: Float, from: Vector2, to: Vector2): Bool {
        final ray = from.createRayFromVector(to);
        final circle = pos.toCircle(radius);
        return circle.testRay(ray) != null;
    }

    public inline static function circleVsPoint(pos: Vector2, radius: Float, point: Vector2): Bool {
        final point = Polygon.square(point.x, point.y, 1, false);
        final circle = pos.toCircle(radius);
        return circle.test(point) != null;
    }

    public inline static function circleVsCircle(pos1: Vector2, radius1: Float, pos2: Vector2, radius2: Float): Bool
        return Math.distanceSquared(pos1.x, pos1.y, pos2.x, pos2.y) < (radius1 + radius2) * (radius1 + radius2);

    public inline static function boundsVsCircle(bounds: Bounds, pos: Vector2, radius: Float): Bool {
        final rect = bounds.toRectangle();
        return rect.test(pos.toCircle(radius)) != null;
    }

    public inline static function boundsVsLine(bounds: Bounds, from: Vector2, to: Vector2): Bool {
        final rect = bounds.toRectangle();
        final ray = from.createRayFromVector(to);
        return rect.testRay(ray) != null;
    }

    public inline static function boundsVsPoint(bounds: Bounds, point: Vector2): Bool
        return bounds.contains(point);

    public inline static function boundsVsBounds(bounds1: Bounds, bounds2: Bounds): Bool
        return bounds1.toRectangle().test(bounds2.toRectangle()) != null;

    public inline static function polyVsPoint(pos: Vector2, polygon: Polygon, point: Vector2): Bool {
        final newPoly = new Polygon(pos.x, pos.y, polygon.transformedVertices);
        return Collision.pointInPoly(point.x, point.y, newPoly);
    }

    public inline static function polyVsLine(pos: Vector2, polygon: Polygon, from: Vector2, to: Vector2): Bool {
        final newPoly = new Polygon(pos.x, pos.y, polygon.transformedVertices);
        final ray = from.createRayFromVector(to);
        return Collision.rayWithShape(ray, newPoly) != null;
    }

    public inline static function polyVsCircle(pos: Vector2, polygon: Polygon, circlePos: Vector2, radius: Float): Bool {
        final newPoly = new Polygon(pos.x, pos.y, polygon.transformedVertices);
        final circle = circlePos.toCircle(radius);
        final test = newPoly.testCircle(circle);
        return test != null;
    }

    public inline static function polyVsRect(pos: Vector2, polygon: Polygon, rect: Rect): Bool {
        final rect = Polygon.rectangle(rect.x, rect.y, rect.width, rect.height);
        rect.rotation = rect.rotation;
        final newPoly = new Polygon(pos.x, pos.y, polygon.transformedVertices);
        return Collision.shapeWithShape(newPoly, rect) != null;
    }

    public inline static function polyVsPoly(posA: Vector2, a: Polygon, posB: Vector2, b: Polygon): Bool {
        final newA = new Polygon(posA.x, posA.y, a.transformedVertices);
        final newB = new Polygon(posB.x, posB.y, b.transformedVertices);
        return Collision.shapeWithShape(newA, newB) != null;
    }

    inline static function verticesToPolygon(vertices: Array<Vector2>): Polygon {
        final vs = vertices.map(v -> new Vector(v.x, v.y));
        return new Polygon(0, 0, vs);
    }

    public inline static function vertsVsPoint(vertices: Array<Vector2>,
            point: Vector2): Bool return polyVsPoint(Vector2.zero,
            verticesToPolygon(vertices), point);

    public inline static function vertsVsCircle(vertices: Array<Vector2>, pos: Vector2,
            radius: Float): Bool return polyVsCircle(Vector2.zero,
            verticesToPolygon(vertices), pos, radius);

    public inline static function vertsVsLine(vertices: Array<Vector2>, from: Vector2,
            to: Vector2): Bool return polyVsLine(Vector2.zero,
            verticesToPolygon(vertices), from, to);

    public inline static function vertsVsRect(vertices: Array<Vector2>, rect: Rect): Bool return polyVsRect(Vector2.zero, verticesToPolygon(vertices),
        rect);

    public inline static function vertsVsPoly(vertices: Array<Vector2>, pos: Vector2,
            poly: Polygon): Bool return polyVsPoly(Vector2.zero,
            verticesToPolygon(vertices), pos, poly);

    public inline static function vertsVsVerts(a: Array<Vector2>, b: Array<Vector2>): Bool return vertsVsPoly(a, Vector2.zero, verticesToPolygon(b));

    inline static function createHitPosition(?test: RayCollision): Option<HitPosition> return if(test != null) {
        final sx = RayCollisionHelper.hitStartX(test);
        final sy = RayCollisionHelper.hitStartY(test);
        final hitEnd = if(test.end <= 1) {
            final ex = RayCollisionHelper.hitEndX(test);
            final ey = RayCollisionHelper.hitEndY(test);
            Some(new Vector2(ex, ey));
        } else {
            None;
        }
        Some({ start: new Vector2(sx, sy), end: hitEnd });
    }
    else {
        None;
    }

    public inline static function rayIntersection(a1: Vector2, a2: Vector2, b1: Vector2, b2: Vector2): Option<Vector2> {
        final aRay = a1.createRayFromVector(a2);
        final bRay = b1.createRayFromVector(b2);
        final test = Collision.rayWithRay(aRay, bRay);
        return if(test != null)
            Some(new Vector2(test.u1, test.u2))
        else
            None;
    }

    public inline static function intersectCircleVsLine(pos: Vector2, radius: Float, from: Vector2,
            to: Vector2): Option<HitPosition> return createHitPosition(Collision.rayWithShape(from.createRayFromVector(to), pos.toCircle(radius)));

    public inline static function intersectBoundsVsLine(bounds: Bounds, from: Vector2, to: Vector2): Option<HitPosition> {
        final rect = bounds.toRectangle();
        return createHitPosition(rect.testRay(from.createRayFromVector(to)));
    }

    public inline static function intersectPolyVsLine(pos: Vector2, polygon: Polygon, from: Vector2, to: Vector2): Option<HitPosition> {
        final ray = from.createRayFromVector(to);
        final newPoly = new Polygon(pos.x, pos.y, polygon.transformedVertices);
        return createHitPosition(Collision.rayWithShape(ray, newPoly));
    }

    public inline static function intersectVertsVsLine(vertices: Array<Vector2>, from: Vector2,
            to: Vector2): Option<HitPosition> return intersectPolyVsLine(Vector2.zero, verticesToPolygon(vertices), from, to);
}
