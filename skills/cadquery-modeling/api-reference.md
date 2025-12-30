# CAD-Query API Quick Reference

Essential methods for 3D modeling. For complete documentation, see `docs/cadquery/classreference.md`.

## Workplane Creation

```python
import cadquery as cq

# Standard workplanes
wp = cq.Workplane("XY")  # Top-down view (default)
wp = cq.Workplane("XZ")  # Front view
wp = cq.Workplane("YZ")  # Side view

# Workplane at offset
wp = cq.Workplane("XY", origin=(0, 0, 10))
```

## 2D Primitives (on workplane)

```python
.rect(width, height)           # Rectangle centered at origin
.circle(radius)                # Circle centered at origin
.ellipse(x_radius, y_radius)   # Ellipse
.polygon(n_sides, diameter)    # Regular polygon
.slot2D(length, diameter)      # Rounded slot shape
```

## 3D Primitives

```python
.box(length, width, height)              # Centered box
.box(l, w, h, centered=(True, True, False))  # Control centering
.cylinder(height, radius)                 # Cylinder along Z
.sphere(radius)                           # Sphere at origin
.wedge(dx, dy, dz, xmin, zmin, xmax, zmax)  # Wedge/pyramid
```

## Extrusion Operations

```python
.extrude(distance)              # Extrude 2D shape into 3D
.extrude(distance, taper=5)     # Tapered extrusion (degrees)
.extrude(distance, both=True)   # Extrude in both directions
.cutThruAll()                   # Cut through entire part
.cutBlind(depth)                # Cut to specific depth
```

## Revolve Operations

```python
.revolve(angleDegrees)          # Revolve around Y axis
.revolve(360, (0, 0, 0), (1, 0, 0))  # Revolve around X axis
```

## Boolean Operations

```python
result.union(other)             # Combine two solids
result.cut(tool)                # Subtract tool from result
result.intersect(other)         # Keep only intersection
```

## Face/Edge Selection

### Directional Selectors
```python
.faces(">Z")    # Topmost face (max Z)
.faces("<Z")    # Bottommost face (min Z)
.faces(">X")    # Rightmost face
.faces("<X")    # Leftmost face
.faces("+Z")    # All faces with normal pointing +Z
.faces("-Z")    # All faces with normal pointing -Z
```

### Edge Selectors
```python
.edges("|Z")    # Edges parallel to Z axis
.edges("#Z")    # Edges perpendicular to Z axis
.edges(">Z")    # Topmost edges
.edges("<Z")    # Bottommost edges
```

### Combining Selectors
```python
.faces(">Z").edges("|X")  # Top face, edges parallel to X
.faces(">Z and <X")       # Topmost AND leftmost faces
.faces(">Z or <Z")        # Top OR bottom faces
```

## Modifications

### Holes
```python
.hole(diameter)                  # Through hole
.hole(diameter, depth)           # Blind hole
.cboreHole(hole_d, cbore_d, cbore_depth)  # Counterbore
.cskHole(hole_d, csk_d, csk_angle)        # Countersink
```

### Fillets and Chamfers
```python
.edges().fillet(radius)          # Fillet all edges
.edges(">Z").fillet(radius)      # Fillet top edges only
.edges().chamfer(distance)       # Chamfer all edges
.edges().chamfer(d1, d2)         # Asymmetric chamfer
```

### Shell (Hollow Out)
```python
.shell(thickness)                # Shell with uniform thickness
.shell(-thickness)               # Shell inward
.faces(">Z").shell(thickness)    # Shell keeping top face open
```

## Patterns

```python
# Linear pattern
.rarray(xSpacing, ySpacing, xCount, yCount)

# Polar pattern (around Z)
.polarArray(radius, startAngle, stopAngle, count)

# Push points for placing features
.pushPoints([(x1, y1), (x2, y2)])
```

## Loft and Sweep

```python
# Loft between profiles
.loft()                          # Loft pending wires
.loft(ruled=True)                # Linear interpolation

# Sweep along path
.sweep(path)                     # Sweep profile along path
.sweep(path, multisection=True)  # Multi-section sweep
```

## Assemblies

```python
from cadquery import Assembly

assy = Assembly()
assy.add(part1, name="base", color=cq.Color("red"))
assy.add(part2, name="top", loc=cq.Location((0, 0, 10)))
```

## Transformations

```python
.translate((x, y, z))            # Move object
.rotate((0, 0, 0), (0, 0, 1), angle)  # Rotate around axis
.mirror("XY")                    # Mirror across plane
```

## Export (handled by MCP server)

The MCP server handles exports, but for reference:

```python
cq.exporters.export(result, "model.stl")
cq.exporters.export(result, "model.step")
```

## Common Gotchas

1. **Workplane context**: Methods operate on the current workplane
2. **Chaining**: Most methods return a new Workplane for chaining
3. **Selection**: Always select faces/edges before operations like fillet
4. **Centering**: `box()` is centered by default; use `centered` param to change
5. **Units**: CAD-Query uses mm by default
6. **show_object()**: Required at end for MCP server processing
