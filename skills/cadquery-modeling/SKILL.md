---
name: cadquery-modeling
description: Creates parametric 3D CAD models using CAD-Query MCP tools. Use when generating 3D designs, creating models for 3D printing, working with STL/STEP files, or describing physical objects to be manufactured. Supports boxes, cylinders, complex assemblies, and parametric designs.
---

# CAD-Query 3D Modeling Skill

Generate parametric 3D models using CAD-Query through MCP tools.

## Capabilities

- Generate CAD-Query Python scripts from natural language descriptions
- Create parametric models with configurable dimensions
- Export to STL (3D printing) and STEP (CAD software) formats
- Validate models before presenting to users
- Support complex assemblies, boolean operations, and sketches

## MCP Tools Available

### `generate_cad_query`

Generates CAD-Query Python scripts from descriptions.

**Parameters:**
- `description` (required): Natural language description of the 3D model
- `parameters` (optional): Specific dimensions or constraints

### `verify_cad_query`

Validates generated CAD models before presenting to users.

**Parameters:**
- `file_path` (required): Path to the CAD-Query Python file
- `verification_criteria` (required): What aspects to verify

## Workflow

### Step 1: Understand Requirements

Before generating, clarify:
- What type of object (mechanical part, container, decorative, etc.)
- Key dimensions in mm (default) or specify units
- Special features (holes, threads, chamfers, fillets)
- Assembly relationships if multiple parts

### Step 2: Study Documentation

Reference the workspace documentation before generating complex models:
- `docs/cadquery/primer.md` - Core concepts and API layers
- `docs/cadquery/classreference.md` - Complete API reference
- `docs/cadquery/selectors.md` - Object selection patterns
- `docs/cadquery/examples.md` - Example gallery

See [api-reference.md](api-reference.md) for common methods.

### Step 3: Generate CAD Code

Call the `generate_cad_query` MCP tool:

```python
generate_cad_query(
    description="Detailed description of the model",
    parameters="height=100, width=50, hole_diameter=10"
)
```

### Step 4: Verify the Model (REQUIRED)

**Always verify before presenting results:**

```python
verify_cad_query(
    file_path="outputs/model_name.py",
    verification_criteria="Description of expected features"
)
```

### Step 5: Present Results

After verification passes:
1. Show the generated Python script
2. Provide the STL file path for 3D printing
3. Explain key modeling decisions

## Script Requirements

All generated scripts must:
1. Import cadquery: `import cadquery as cq`
2. Use `cq.Workplane()` as the starting point
3. End with `show_object(result)` for MCP processing

```python
import cadquery as cq

# Your modeling code here
result = cq.Workplane("XY").box(10, 10, 10)

show_object(result)  # Required for MCP server
```

## Common Patterns

### Basic Shapes

```python
# Box with hole
result = cq.Workplane("XY").box(20, 20, 10).faces(">Z").hole(5)

# Cylinder
result = cq.Workplane("XY").cylinder(height=30, radius=10)

# Shell (hollow object)
result = cq.Workplane("XY").box(20, 20, 20).shell(2)
```

### Boolean Operations

```python
# Union (combine)
result = part1.union(part2)

# Cut (subtract)
result = base.cut(tool)

# Intersect
result = part1.intersect(part2)
```

### Selections

```python
# Select top face
.faces(">Z")

# Select bottom face
.faces("<Z")

# Select all vertical edges
.edges("|Z")

# Select largest face
.faces(">Z", tag="top").faces(">Z")
```

### Chamfers and Fillets

```python
# Fillet all edges
result = box.edges().fillet(1)

# Chamfer specific edges
result = box.edges(">Z").chamfer(0.5)
```

## Output Files

The MCP server generates files in `outputs/`:
- `{model_name}.py` - CAD-Query Python source
- `{model_name}.stl` - STL for 3D printing
- `{model_name}.step` - STEP for CAD software

## Tips for Better Models

1. **Be specific about dimensions** - Include units (mm preferred)
2. **Describe features clearly** - "hole through the center" vs "blind hole 5mm deep"
3. **Mention tolerances** if precision matters
4. **For assemblies** - Describe how parts connect
5. **Reference examples** - Look at `examples/` for similar models

## Example Requests

Good:
> "Create a coffee mug, 100mm tall, 80mm diameter, with a 15mm wide handle on the side. Wall thickness 3mm."

Better:
> "Create a coffee mug:
> - Height: 100mm
> - Outer diameter: 80mm
> - Wall thickness: 3mm
> - Handle: C-shaped, 15mm wide, attached at 20mm and 70mm from base
> - Bottom: solid, 5mm thick"

## Error Handling

If verification fails:
1. Review the error message
2. Check the generated script against documentation
3. Adjust parameters and regenerate
4. Re-verify before presenting
