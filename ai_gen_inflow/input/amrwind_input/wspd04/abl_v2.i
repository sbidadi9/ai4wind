#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#            SIMULATION CONTROL         #
#.......................................#
time.stop_time                           = 57.1             # Max (simulated) time to evolve [s]
time.max_step                            = -1          # Max number of time steps
time.fixed_dt                            = 0.01          # Use this constant dt if > 0
#time.cfl                                 = 0.95         # CFL factor

time.plot_interval                       = 500 #5000       # Steps between plot files
time.checkpoint_interval                 = 500 #5000       # Steps between checkpoint files

ABL.bndry_file                           = /scratch/sbidadi/ai4wind/amrwind_inflow_bc.nc
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
xlo.temperature                          = 265.0    
xlo.vof = 0.0 
xhi.type                                 = pressure_outflow  

#xlo.type = "mass_inflow_outflow"
#xlo.density = 1.027
#xlo.temperature                          = 312.   
#xlo.vof = 1.0
#
#xhi.type = "mass_inflow_outflow"
#xhi.density = 1.027
#xhi.temperature                          = 312.
#xhi.velocity = 1 0 0 

zlo.type                                 = slip_wall
zhi.type                                 = slip_wall
zhi.temperature_type                     = fixed_gradient
zhi.temperature                          = 0.003

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#               PHYSICS                 #
#.......................................#
incflo.physics                           = MultiPhase ABL OceanWaves
ICNS.source_terms                        = BoussinesqBuoyancy ABLMeanBoussinesq CoriolisForcing GeostrophicForcing GravityForcing

##--------- Additions by calc_inflow_stats.py ---------#
ABL.wall_shear_stress_type = "local"
ABL.inflow_outflow_mode = true
ABL.wf_velocity = -0.03919492939325914 0.014681554327541356
ABL.wf_vmag = 0.05594884477843705
ABL.wf_theta = 265 
BodyForce.magnitude = 0.0 0.0 0.0 
BoussinesqBuoyancy.read_temperature_profile = true
BoussinesqBuoyancy.tprofile_filename = avg_theta.dat
#######################################################

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
ABL.temperature_heights                  = 0.0 475.0 575.0 2000.0
ABL.temperature_values                   = 265.0 265.0 273.0 277.275
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
OceanWaves.Wave1.water_depth             = 910.0
OceanWaves.Wave1.relax_zone_gen_length   = 400.0
#OceanWaves.Wave1.relax_zone_out_length   = 800.0
OceanWaves.Wave1.numerical_beach_length  = 400.0
OceanWaves.Wave1.numerical_beach_length_factor  = 2.0 
OceanWaves.Wave1.initialize_wave_field   = true
OceanWaves.label.wave_phase_offset_degrees = 123.75

#¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨#
#            MESH REFINEMENT            #   
#.......................................#
tagging.labels                           = static
tagging.static.type                      = CartBoxRefinement
tagging.static.static_refinement_def     = static_box.txt

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

#diffusion.mg_rtol                                  = -1
#diffusion.mg_atol                                  = 1e-4
#temperature_diffusion.mg_rtol                      = -1
#temperature_diffusion.mg_atol                      = 1e-4

#nodal_proj.num_pre_smooth                          = 8 
#nodal_proj.num_post_smooth                         = 8 
#nodal_proj.mg_rtol                                 = 1.0e-3 
#nodal_proj.mg_atol                                 = 1.0e-4 
#nodal_proj.maxiter                                 = 25  
#nodal_proj.fmg_maxiter                             = 4
