# CAD-Query Example Patterns

Reference examples for common modeling tasks. Study these patterns before generating complex models.

## Simple Box with Hole

```python
import cadquery as cq

# Create a box with a through-hole in the center
result = cq.Workplane("XY").box(20, 20, 10).faces(">Z").hole(5)

show_object(result)
```

**Pattern**: Basic primitive + face selection + hole operation

## Hollow Container (Shell)

```python
import cadquery as cq

# Create a hollow box (like a tray)
result = (
    cq.Workplane("XY")
    .box(50, 30, 20)
    .faces(">Z")
    .shell(-2)  # 2mm wall thickness, open top
)

show_object(result)
```

**Pattern**: Box + shell operation with face selection to keep open

## Rounded Box (Fillets)

```python
import cadquery as cq

# Box with all edges filleted
result = (
    cq.Workplane("XY")
    .box(30, 20, 15)
    .edges()
    .fillet(2)
)

show_object(result)
```

**Pattern**: Primitive + edge selection + fillet

## Coffee Mug

```python
import cadquery as cq

# Create the main mug body (cylinder with thick walls)
mug_body = cq.Workplane("XY").cylinder(height=100, radius=40).faces(">Z").shell(-3)

# Create handle attachment points
attachment_top = (
    cq.Workplane("XY")
    .center(40, 0)
    .cylinder(height=10, radius=4)
    .translate((0, 0, 70))
)

attachment_bottom = (
    cq.Workplane("XY")
    .center(40, 0)
    .cylinder(height=10, radius=4)
    .translate((0, 0, 20))
)

# Create the curved handle body
handle_body = (
    cq.Workplane("XY")
    .center(55, 0)
    .box(10, 8, 50)
    .translate((0, 0, 45))
)

# Combine handle parts
handle = attachment_top.union(attachment_bottom).union(handle_body)

# Combine everything
result = mug_body.union(handle)

show_object(result)
```

**Pattern**: Multiple parts created separately, combined with union

## Bracket with Mounting Holes

```python
import cadquery as cq

# L-shaped bracket with mounting holes
result = (
    cq.Workplane("XY")
    .box(50, 30, 5)  # Base plate
    .faces(">Y")
    .workplane()
    .box(50, 5, 40, centered=(True, False, False))  # Vertical plate
    .faces("<Z")
    .workplane()
    .pushPoints([(-15, 0), (15, 0)])  # Two hole positions
    .hole(5)  # Mounting holes
    .faces(">Z")
    .workplane()
    .center(0, 15)
    .pushPoints([(-15, 0), (15, 0)])
    .hole(5)
)

show_object(result)
```

**Pattern**: Multi-face workplanes + pushPoints for hole patterns

## Cylinder with Flange

```python
import cadquery as cq

# Pipe with flange at bottom
pipe = cq.Workplane("XY").circle(20).extrude(60)
flange = cq.Workplane("XY").circle(35).extrude(5)

# Hollow out
result = (
    pipe.union(flange)
    .faces(">Z")
    .shell(-3)
)

# Add mounting holes to flange
result = (
    result.faces("<Z")
    .workplane()
    .polarArray(27, 0, 360, 4)
    .hole(5)
)

show_object(result)
```

**Pattern**: Union primitives + shell + polar array for bolt pattern

## Swept Profile (Pipe Elbow)

```python
import cadquery as cq

# Create a pipe elbow using sweep
path = (
    cq.Workplane("XZ")
    .moveTo(0, 0)
    .radiusArc((30, 30), 30)
)

result = (
    cq.Workplane("XY")
    .circle(10)
    .sweep(path)
)

show_object(result)
```

**Pattern**: 2D profile swept along a path

## Revolved Profile (Vase)

```python
import cadquery as cq

# Create a vase by revolving a profile
result = (
    cq.Workplane("XZ")
    .moveTo(20, 0)
    .lineTo(25, 0)
    .lineTo(30, 20)
    .lineTo(25, 60)
    .lineTo(30, 80)
    .lineTo(25, 80)
    .lineTo(20, 60)
    .lineTo(25, 20)
    .close()
    .revolve(360, (0, 0, 0), (0, 1, 0))
)

show_object(result)
```

**Pattern**: 2D sketch revolved around axis

## Multi-Body Assembly

```python
import cadquery as cq
from cadquery import Assembly, Color, Location

# Create individual parts
base = cq.Workplane("XY").box(100, 60, 10)
post = cq.Workplane("XY").cylinder(50, 10)
cap = cq.Workplane("XY").cylinder(5, 15).faces(">Z").chamfer(2)

# Create assembly
assy = Assembly()
assy.add(base, name="base", color=Color("gray"))
assy.add(post, name="post", loc=Location((0, 0, 10)), color=Color("blue"))
assy.add(cap, name="cap", loc=Location((0, 0, 60)), color=Color("red"))

show_object(assy)
```

**Pattern**: Separate parts + Assembly for positioning

## Lofted Shape (Transition)

```python
import cadquery as cq

# Square to circle transition
result = (
    cq.Workplane("XY")
    .rect(40, 40)
    .workplane(offset=30)
    .circle(15)
    .loft()
)

show_object(result)
```

**Pattern**: Multiple profiles + loft to create smooth transition

## Threaded Hole (Simplified)

```python
import cadquery as cq

# Block with counterbored holes for socket head cap screws
result = (
    cq.Workplane("XY")
    .box(60, 40, 20)
    .faces(">Z")
    .workplane()
    .pushPoints([(-20, 0), (20, 0)])
    .cboreHole(5, 10, 5)  # M5 hole, 10mm counterbore, 5mm deep
)

show_object(result)
```

**Pattern**: Counterbore holes for fasteners

## Enclosure with Lip

```python
import cadquery as cq

# Bottom half of enclosure with mating lip
box_w, box_d, box_h = 80, 50, 25
wall = 2
lip = 1.5

# Main body
body = (
    cq.Workplane("XY")
    .box(box_w, box_d, box_h)
    .faces(">Z")
    .shell(-wall)
)

# Add lip around top edge
lip_profile = (
    cq.Workplane("XY")
    .workplane(offset=box_h/2 - wall)
    .rect(box_w - wall*2, box_d - wall*2)
    .extrude(lip)
)

result = body.union(lip_profile)

show_object(result)
```

**Pattern**: Shell + additional geometry for mating features

## Selecting Multiple Features

```python
import cadquery as cq

# Demonstrate complex selection
result = (
    cq.Workplane("XY")
    .box(40, 30, 20)
    # Fillet only vertical edges
    .edges("|Z")
    .fillet(3)
    # Chamfer only top edges
    .edges(">Z")
    .chamfer(1)
)

show_object(result)
```

**Pattern**: Chained selections with different operations
