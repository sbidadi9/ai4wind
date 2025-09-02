#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#            SIMULATION CONTROL         #
#.......................................#
time.stop_time                           = 60.0 #99999.0             # Max (simulated) time to evolve [s]
time.max_step                            = -1          # Max number of time steps
time.fixed_dt                            = 0.01          # Use this constant dt if > 0
time.cfl                                 = 0.95         # CFL factor

time.plot_interval                       = 200 #1000       # Steps between plot files
time.checkpoint_interval                 = 200 #1000       # Steps between checkpoint files

ABL.bndry_file                           = amrwind_wspd_10_ai_inflow_bc_fine_mesh.nc
#ABL.bndry_file                           = wspd5-sample00_out.nc
ABL.bndry_output_format                  = netcdf
ABL.bndry_io_mode                        = 1
ABL.bndry_planes                         = xlo
ABL.bndry_output_start_time              = 0.0 #11169.61549
ABL.bndry_var_names                      = velocity temperature # tke
#ABL.stats_output_frequency               = 5  # Frequency is rapid for the sake of reg test
#ABL.normal_direction                               = 2

#io.restart_file                          = /projects/ai4wind/orybchuk/windai/simulations/maine_sweep/wspd28/lev2/chk167500
io.outputs                               = velocity_mueff temperature_mueff
incflo.use_godunov                       = 1
incflo.diffusion_type                    = 2
incflo.godunov_type                      = weno_z
incflo.mflux_type                        = minmod
turbulence.model                         = Laminar
#TKE.source_terms                         = KsgsM84Src
#TKE.interpolation                        = PiecewiseConstant          
incflo.gravity                           = 0.  0. -9.81  # Gravitational force (3D)
incflo.density                           = 1.027          # Reference density
transport.model                          = TwoPhaseTransport
transport.viscosity_fluid1               = 1e-3
transport.viscosity_fluid2               = 1e-5
transport.laminar_prandtl_fluid1         = 7.2
transport.laminar_prandtl_fluid2         = 0.7
transport.turbulent_prandtl              = 0.3333
MultiPhase.density_fluid1                = 1020.
MultiPhase.density_fluid2                = 1.027
MultiPhase.water_level                   = 0.

incflo.verbose                           =   0          # incflo_level

incflo.do_initial_proj=0
incflo.initial_iterations=0

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#            GEOMETRY & BCs             #
#.......................................#
geometry.prob_lo                         = 0.       0.    -180  # Lo corner coordinates
geometry.prob_hi                         = 1200.   840.   180  # Hi corner coordinates; 600 / 128 = 4.6875 m resolution
#amr.n_cell                               = 480 168 72   # Grid cells at coarsest AMRlevel; pick round dx for nice sampling
amr.n_cell                               = 960 672 288   # Grid cells at coarsest AMRlevel; pick round dx for nice sampling


amr.max_level                            = 0 #2           # Max AMR level in hierarchy 
#geometry.is_periodic                     = 1   1   0   # Periodicity x y z (0/1)
geometry.is_periodic                     = 0   1   0   # Periodicity x y z (0/1)


xlo.type                                 = mass_inflow    
xlo.density                              = 1.027    
xlo.temperature                          = 263.95    
xlo.vof = 0.0 
xhi.type                                 = pressure_outflow  

#ylo.type                                 = mass_inflow         
#ylo.density                              = 1.027               
#ylo.temperature                          = 312.0               
#ylo.tke                                  = 0.0
#yhi.type                                 = pressure_outflow     

#ylo.type                                 = slip_wall
#yhi.type                                 = slip_wall

zlo.type                                 = slip_wall
zhi.type                                 = slip_wall
zhi.temperature_type                     = fixed_gradient
zhi.temperature                          = 0.0

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#               PHYSICS                 #
#.......................................#
incflo.physics                           = MultiPhase ABL OceanWaves
#ICNS.source_terms                        = BoussinesqBuoyancy ABLMeanBoussinesq CoriolisForcing GeostrophicForcing GravityForcing
ICNS.source_terms                        = BoussinesqBuoyancy CoriolisForcing GeostrophicForcing GravityForcing
ICNS.use_perturb_pressure                = true

incflo.velocity                          = 10.0 0.0 0.0

GeostrophicForcing.geostrophic_wind      = 10.0 0.0 0.0
GeostrophicForcing.wind_forcing_off_height  = 3.0
GeostrophicForcing.wind_forcing_ramp_height = 7.0

CoriolisForcing.latitude                 = 90.0
CoriolisForcing.north_vector             = 0.0 1.0 0.0
CoriolisForcing.east_vector              = 1.0 0.0 0.0

BoussinesqBuoyancy.reference_temperature = 265.0
#BoussinesqBuoyancy.read_temperature_profile = true
#BoussinesqBuoyancy.tprofile_filename = avg_theta.dat

ABL.reference_temperature                = 263.95
#ABL.temperature_heights                  = 0.0 475.0 575.0 1575.0
#ABL.temperature_values                   = 265.0 265.0 273.0 276.0

ABL.temperature_heights                  = 0.0 600.0
ABL.temperature_values                   = 263.95 263.95


ABL.perturb_temperature                  = false
ABL.cutoff_height                        = 50.0
ABL.perturb_velocity                     = true
ABL.perturb_ref_height                   = 50.0
ABL.Uperiods                             = 4.0
ABL.Vperiods                             = 4.0
ABL.deltaU                               = 1e-5
ABL.deltaV                               = 1e-5
ABL.kappa                                = .41
ABL.surface_roughness_z0                 = 0.0002
ABL.surface_temp_flux                    = 0.0
#ABL.surface_temp_rate                    = -0.325
#ABL.initial_wind_profile                           = true
#ABL.rans_1dprofile_file                            = "init_vel.txt"

OceanWaves.label                         = Wave1
OceanWaves.Wave1.type                    = LinearWaves
OceanWaves.Wave1.initialize_wave_field   = true
OceanWaves.Wave1.wave_height             = 1.6
OceanWaves.Wave1.wave_length             = 25.0
OceanWaves.Wave1.water_depth             = 180.0 
OceanWaves.Wave1.relax_zone_gen_length   = 150.0
#OceanWaves.Wave1.relax_zone_out_length   = 800.0
OceanWaves.label.zero_sea_level          = 0.0

OceanWaves.Wave1.numerical_beach_length  = 400.0
OceanWaves.Wave1.numerical_beach_length_factor  = 2.0
#OceanWaves.label.wave_phase_offset_degrees = 27.13

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#          POST-Processing              #
#.......................................#
# io.output_hdf5_plotfile                  = true
# io.hdf5_compression                      = "ZFP_ACCURACY@0.001"

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#          POST-Processing              #   
#.......................................#
incflo.post_processing  = slices

slices.output_format    = netcdf
slices.output_frequency = 10  
slices.fields           = velocity
slices.labels           = box1

# High sampling grid spacing = 2.5 m
slices.box1.type         = PlaneSampler
slices.box1.num_points   =    336   144   
slices.box1.origin       =    0.0      0.0 -180.0 
slices.box1.axis1        =    0.0    840.0    0.0 
slices.box1.axis2        =    0.0      0.0  360.0 
slices.box1.offsets      = 100.0 200.0 300.0 400.0 500.0
slices.box1.offset_vector       =    1.0      0.0    0.0 

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#              AVERAGING                #
#.......................................#


#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#            MESH REFINEMENT            #
#.......................................#
#tagging.labels                           = static
#tagging.static.type                      = CartBoxRefinement
#tagging.static.static_refinement_def     = static_box.txt

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#               TURBINES                #
#.......................................#

mac_proj.num_pre_smooth                            = 8
mac_proj.num_post_smooth                           = 8
mac_proj.mg_rtol                                   = -1
mac_proj.mg_atol                                   = 1e-4
mac_proj.maxiter                                   = 25
mac_proj.fmg_maxiter                               = 4

nodal_proj.num_pre_smooth                          = 8
nodal_proj.num_post_smooth                         = 8
nodal_proj.mg_rtol                                 = -1
nodal_proj.mg_atol                                 = 1e-4
nodal_proj.maxiter                                 = 25
nodal_proj.fmg_maxiter                             = 4
