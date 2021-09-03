# 1D wave equation
# elasticity basic: see (modules/tensor_mechanics/test/tests/ad_elastic/finite_elastic.i)

# TODO: test PresetDisplacemenet, see
# (modules/tensor_mechanics/test/tests/dynamics/prescribed_displacement/3D_QStatic_1_Ramped_Displacement.i)
# use a half sine wave

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

[AuxVariables] 
  [./accel_x]
  [../]
  [./vel_x]
  [../]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  [./DynamicTensorMechanics] # zeta*K*vel + K * disp
    displacements = 'disp_x'
    # stiffness_damping_coefficient = 0.000025
  [../]
  [./inertia_x] # M*accel + eta*M*vel
    type = InertialForce
    variable = disp_x
    velocity = vel_x
    acceleration = accel_x
    beta = 0.25 # Newmark time integration
    gamma = 0.5 # Newmark time integration
    eta = 19.63
  [../]
[]

[AuxKernels]
  [./accel_x] # Calculates and stores acceleration at the end of time step
    type = NewmarkAccelAux
    variable = accel_x
    displacement = disp_x
    velocity = vel_x
    beta = 0.25
    execute_on = timestep_end
  [../]
  [./vel_x] # Calculates and stores velocity at the end of the time step
    type = NewmarkVelAux
    variable = vel_x
    acceleration = accel_x
    gamma = 0.5
    execute_on = timestep_end
  [../]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./strain_xx]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_xx
    index_i = 0
    index_j = 0
  [../]
[]

[Functions]
  [./displacement_right]
    type = ParsedFunction
    value = "if(t <= 1, sin(2*pi*t), 0)"
  [../]
[]

[BCs]
  [./leftBC]
    type = DirichletBC
    variable = disp_x
    boundary = left
    value = 0
  [../]
  [./rightBC] # Preset_displacement
    type = PresetDisplacement
    variable = disp_x
    function = displacement_right
    boundary = right
    beta = 0.25
    velocity = vel_x
    acceleration = accel_x
  [../]
[]

[Materials]
  [./elasticity]
    type = ComputeIsotropicElasticityTensor
    poissons_ratio = 0.3
    youngs_modulus = 325e6 #Pa
  [../]
  [./strain]
    type = ComputeSmallStrain
    block = 0
    displacement = 'disp_x'
  [../]
  [./stress]
    type = ComputeLinearElasticStress
    block = 0
  [../]
  [./density]
    type = GenericConstantMaterial
    block = 0
    prop_names = density
    prop_values = 2000 #kg/m3
  [../]
[]

[Executioner]
  type = Transient
  start_time = 0
  end_time = 3.0
  l_tol = 1e-6
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-6
  dt = 0.1
  timestep_tolerance = 1e-6
[]

[Outputs]
  exodus = true
[]