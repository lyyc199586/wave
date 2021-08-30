# 1D wave equation
# see (modules/tensor_mechanics/test/tests/ad_elastic/finite_elastic.i)
[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 10
  xmin = 0.0
  xmax = 1.0
[]

[GlobalParams]
  displacements = 'disp_x'
[]

[Variables]
  [./disp_x]
    scaling = 1e-10
  [../]
[]

[Kernels]
  [./stress_x]
    type = ADStressDivergenceTensors
    component = 0
    variable = disp_x
    use_displaced_mesh = true
  [../]
[]

[BCs]
  [./leftBC]
    type = DirichletBC
    variable = disp_x
    boundary = left
    value = 0
  [../]
  [./rightBC]
    type = DirichletBC
    variable = disp_x
    boundary = right
    value = 0.1
  [../]
[]

[Materials]
  [./elasticity]
    type = ADComputeIsotropicElasticityTensor
    poissons_ratio = 0.3
    youngs_modulus = 1e10
  [../]
[]

[Materials]
  [./strain]
    type = ADComputeFiniteStrain
  [../]
  [./stress]
    type = ADComputeFiniteStrainElasticStress
  [../]
[]

[Executioner]
  type = Transient
  dt = 0.05
  solve_type = 'NEWTON'

  petsc_options_iname = -pc_hypre_type
  petsc_options_value = boomeramg

  dtmin = 0.05
  num_steps = 1
[]

[Outputs]
  exodus = true
[]