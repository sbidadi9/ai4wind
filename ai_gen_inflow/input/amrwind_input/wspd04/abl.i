#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#            SIMULATION CONTROL         #
#.......................................#
time.stop_time                           = 58.1             # Max (simulated) time to evolve [s]
time.max_step                            = -1          # Max number of time steps
time.fixed_dt                            = 0.01          # Use this constant dt if > 0
time.cfl                                 = 0.95         # CFL factor

time.plot_interval                       = 5000       # Steps between plot files
time.checkpoint_interval                 = 5000       # Steps between checkpoint files

ABL.bndry_file                           = amrwind_inflow_bc.nc
ABL.bndry_output_format                  = netcdf
ABL.bndry_io_mode                        = 1
ABL.bndry_planes                         = xlo
ABL.bndry_output_start_time              = 0.0
ABL.bndry_var_names                      = velocity temperature # tke
# ABL.stats_output_frequency               = 5  # Frequency is rapid for the sake of reg test

#io.restart_file                          = /projects/ai4wind/orybchuk/windai/simulations/maine_sweep/wspd04/lev2_cont1/chk192500
io.outputs                               = velocity_mueff temperature_mueff
incflo.use_godunov                       = 1
incflo.diffusion_type                    = 1
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
geometry.prob_lo                         = 0.       0.     -910.  # Lo corner coordinates
geometry.prob_hi                         = 2400.   3420.   1910.  # Hi corner coordinates; 600 / 128 = 4.6875 m resolution
amr.n_cell                               = 320 456 376    # Grid cells at coarsest AMRlevel; pick round dx for nice sampling
amr.max_level                            = 2           # Max AMR level in hierarchy 
geometry.is_periodic                     = 0   1   0   # Periodicity x y z (0/1)
#incflo.delp                              = 0.  0.  0.  # Prescribed (cyclic) pressure gradient

xlo.type                                 = mass_inflow    
xlo.density                              = 1.027    
xlo.temperature                          = 312.0    
xlo.vof = 0.0 
#xlo.tke                                  = 0.0 
xhi.type                                 = pressure_outflow  

#ylo.type                                 = mass_inflow         
#ylo.density                              = 1.027               
#ylo.temperature                          = 312.0               
#ylo.tke                                  = 0.0
#yhi.type                                 = pressure_outflow     

zlo.type                                 = slip_wall
zhi.type                                 = slip_wall
zhi.temperature_type                     = fixed_gradient
zhi.temperature                          = 0.01

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#               PHYSICS                 #
#.......................................#
incflo.physics                           = MultiPhase ABL OceanWaves
ICNS.source_terms                        = BoussinesqBuoyancy CoriolisForcing GeostrophicForcing GravityForcing
ICNS.use_perturb_pressure                = true
incflo.velocity                          = 4.0 0.0 0.0
GeostrophicForcing.geostrophic_wind      = 4.0 0.0 0.0
GeostrophicForcing.wind_forcing_off_height  = 12.0
GeostrophicForcing.wind_forcing_ramp_height = 16.0
CoriolisForcing.latitude                 = 90.0
CoriolisForcing.north_vector             = 0.0 1.0 0.0
CoriolisForcing.east_vector              = 1.0 0.0 0.0
BoussinesqBuoyancy.reference_temperature = 265
ABL.reference_temperature                = 265
ABL.temperature_heights                  = 0.0 475.0 575.0 1575.0
ABL.temperature_values                   = 265.0 265.0 273.0 276.0
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
#ABL.surface_temp_rate                    = -0.321

OceanWaves.label                         = Wave1
OceanWaves.Wave1.type                    = LinearWaves
OceanWaves.Wave1.wave_height             = 12
OceanWaves.Wave1.wave_length             = 400.0
OceanWaves.Wave1.water_depth             = 400.0
OceanWaves.Wave1.relax_zone_gen_length   = 400.0
OceanWaves.Wave1.relax_zone_out_length   = 800.0
# OceanWaves.Wave1.numerical_beach_length  = 50.0
# OceanWaves.Wave1.numerical_beach_length_factor  = 1.0
OceanWaves.Wave1.initialize_wave_field   = true
OceanWaves.label.wave_phase_offset_degrees = 123.75

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#          POST-Processing              #
#.......................................#
# io.output_hdf5_plotfile                  = true
# io.hdf5_compression                      = "ZFP_ACCURACY@0.001"

# incflo.post_processing                   = sampling
# sampling.output_frequency                = 1
# sampling.fields                          = vof velocity
# sampling.labels                          = yz0 xz0 yz1 xz1 yz2 xz2

# Lev0 resolution = 7.5 m, along-wind plane, whole vertical extent of lev0 [-400, 1400]
sampling.yz0.type                        = PlaneSampler
sampling.yz0.num_points                  = 320 240
sampling.yz0.origin                      = 50.0 0.0 -400
sampling.yz0.axis1                       = 0.0 2392.5 0.0
sampling.yz0.axis2                       = 0.0 0.0 1792.5
sampling.yz0.offset_vector               = 1.0 0.0 0.0
sampling.yz0.offsets                     = 0.0 100.0 200.0 300.0 400.0 500.0 600.0 700.0 800.0 900.0 1000.0 1100.0 1200.0 1300.0 1400.0 1500.0 1600.0 1700.0 1800.0 1900.0 2000.0 2100.0 2200.0 2300.0

sampling.xz0.type                        = PlaneSampler
sampling.xz0.num_points                  = 320 240
sampling.xz0.origin                      = 0.0 1200.0 -400
sampling.xz0.axis1                       = 2392.5 0.0 0.0
sampling.xz0.axis2                       = 0.0 0.0 1792.5

# Lev1 resolution = 3.75 m, along-wind plane, whole vertical extent of lev1 [-70, 80]
sampling.yz1.type                        = PlaneSampler
sampling.yz1.num_points                  = 640 40
sampling.yz1.origin                      = 50.0 0.0 -70
sampling.yz1.axis1                       = 0.0 2396.25 0.0
sampling.yz1.axis2                       = 0.0 0.0 146.25
sampling.yz1.offset_vector               = 1.0 0.0 0.0
sampling.yz1.offsets                     = 0.0 100.0 200.0 300.0 400.0 500.0 600.0 700.0 800.0 900.0 1000.0 1100.0 1200.0 1300.0 1400.0 1500.0 1600.0 1700.0 1800.0 1900.0 2000.0 2100.0 2200.0 2300.0

sampling.xz1.type                        = PlaneSampler
sampling.xz1.num_points                  = 640 40
sampling.xz1.origin                      = 0.0 1200.0 -70
sampling.xz1.axis1                       = 2396.25 0.0 0.0
sampling.xz1.axis2                       = 0.0 0.0 146.25

# Lev2 resolution = 1.875 m, along-wind plane, whole vertical extent of lev2 [-40, 50]
sampling.yz2.type                        = PlaneSampler
sampling.yz2.num_points                  = 1280 48
sampling.yz2.origin                      = 50.0 0.0 -40
sampling.yz2.axis1                       = 0.0 2398.125 0.0
sampling.yz2.axis2                       = 0.0 0.0 88.125
sampling.yz2.offset_vector               = 1.0 0.0 0.0
sampling.yz2.offsets                     = 0.0 100.0 200.0 300.0 400.0 500.0 600.0 700.0 800.0 900.0 1000.0 1100.0 1200.0 1300.0 1400.0 1500.0 1600.0 1700.0 1800.0 1900.0 2000.0 2100.0 2200.0 2300.0

sampling.xz2.type                        = PlaneSampler
sampling.xz2.num_points                  = 1280 48
sampling.xz2.origin                      = 0.0 1200.0 -40
sampling.xz2.axis1                       = 2398.125 0.0 0.0
sampling.xz2.axis2                       = 0.0 0.0 88.125

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#              AVERAGING                #
#.......................................#


#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#            MESH REFINEMENT            #
#.......................................#
tagging.labels                           = static
tagging.static.type                      = CartBoxRefinement
tagging.static.static_refinement_def     = static_box.txt

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#               TURBINES                #
#.......................................#
