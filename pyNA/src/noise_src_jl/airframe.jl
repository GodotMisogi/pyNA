function trailing_edge_wing(settings::PyObject, ac::PyObject, freq::Array{Float64, 1}, M_0, c_0, rho_0, mu_0, theta, phi)
    
    ### ---------------- Wing trailing-edge noise ----------------
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 5
    delta_w_star = 0.37 * (ac.af_S_w / ac.af_b_w^2) * (rho_0 * M_0 * c_0 * ac.af_S_w / (mu_0 * ac.af_b_w))^(-0.2)

    # Determine configuration constant and the sound power
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 7
    if ac.af_clean_w == 0
        K_w = 4.464e-5
    elseif ac.af_clean_w == 1
        K_w = 7.075e-6
    end

    Pi_star_w = K_w * M_0^5 * delta_w_star

    # Determine directivity function
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 8
    D_w = 4. * cos(phi * π / 180.)^2 * cos(theta / 2 * π / 180.)^2

    # Determine spectral distribution function
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 10-11-12
    S_w = freq * delta_w_star * ac.af_b_w / (M_0 * c_0) * (1 - M_0 * cos(theta * π / 180.))
    if ac.af_delta_wing == 1
        F_w = 0.613 * (10 * S_w).^4 .* ((10 * S_w).^1.35 .+ 0.5).^(-4)
    elseif ac.af_delta_wing == 0
        F_w = 0.485 * (10 * S_w).^4 .* ((10 * S_w).^1.5 .+ 0.5).^(-4)
    end
    
    # Determine msap
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 1
    r_s_star_af = settings.r_0 / ac.af_b_w
    msap_w = 1 / (4 * π * r_s_star_af^2) / (1 - M_0 * cos(theta * π / 180.))^4 * (Pi_star_w * D_w * F_w)

    #Write output
    return msap_w
end
function trailing_edge_horizontal_tail(settings::PyObject, ac::PyObject, freq::Array{Float64, 1}, M_0, c_0, rho_0, mu_0, theta, phi)

    # ---------------- Horizontal tail trailing-edge noise ----------------
    # Trailing edge noise of the horizontal tail
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 5
    delta_h_star = 0.37 * (ac.af_S_h / ac.af_b_h^2) * (rho_0 * M_0 * c_0 * ac.af_S_h / (mu_0 * ac.af_b_h))^(-0.2)
    
    # Determine configuration constant and the sound power
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 7
    if ac.af_clean_h == 0
        K_h = 4.464e-5
    elseif ac.af_clean_h == 1
        K_h = 7.075e-6
    end
    Pi_star_h = K_h * M_0^5 * delta_h_star * (ac.af_b_h / ac.af_b_w)^2
    
    # Determine the directivity function
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 8
    D_h = 4 * cos(phi * π / 180.)^2 * cos(theta / 2 * π / 180.)^2
    
    # Determine spectral distribution function
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 10-11-12
    S_h = freq * delta_h_star * ac.af_b_h / (M_0 * c_0) * (1 - M_0 * cos(theta * π / 180.))
    F_h = 0.485 * (10 * S_h).^4 .* ((10 * S_h).^1.5 .+ 0.5).^(-4)
    
    # Determine msap
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 1
    r_s_star_af = settings.r_0 / ac.af_b_w
    msap_h = 1. / (4. * π * r_s_star_af^2) / (1 - M_0 * cos(theta * π / 180.))^4 * (Pi_star_h * D_h * F_h)

    return msap_h
end  
function trailing_edge_vertical_tail(settings::PyObject, ac::PyObject, freq::Array{Float64, 1}, M_0, c_0, rho_0, mu_0, theta, phi)

    ### ---------------- Vertical tail trailing-edge noise ----------------
    delta_v_star = 0.37 * (ac.af_S_v / ac.af_b_v^2) * (rho_0 * M_0 * c_0 * ac.af_S_v / (mu_0 * ac.af_b_v))^(-0.2)

    # Trailing edge noise of the vertical tail
    if ac.af_clean_v == 0
        K_v = 4.464e-5
    elseif ac.af_clean_v == 1
        K_v = 7.075e-6
    end
    
    Pi_star_v = K_v * M_0^5 * delta_v_star * (ac.af_b_v / ac.af_b_w)^2

    # Determine directivity function
    D_v = 4 * sin(phi * π / 180.)^2 * cos(theta / 2 * π / 180.)^2

    # Determine spectral distribution function
    S_v = freq * delta_v_star * ac.af_b_v / (M_0 * c_0) * (1 - M_0 * cos(theta * π / 180.))
    
    if ac.af_delta_wing == 1
        F_v = 0.613 * (10 * S_v).^4 .* ((10 * S_v).^1.35 .+ 0.5).^(-4)
    elseif ac.af_delta_wing == 0
        F_v = 0.485 * (10 * S_v).^4 .* ((10 * S_v).^1.35 .+ 0.5).^(-4)
    end
    
    # Determine msap
    r_s_star_af = settings.r_0 / ac.af_b_w
    msap_v = 1. / (4 * π * r_s_star_af^2) / (1 - M_0 * cos(theta * π / 180.))^4 * (Pi_star_v * D_v * F_v)

    return msap_v
end
function leading_edge_slat(settings::PyObject, ac::PyObject, freq::Array{Float64, 1}, M_0, c_0, rho_0, mu_0, theta, phi)

    ### ---------------- Slat noise ----------------
    delta_w_star = 0.37 * (ac.af_S_w / ac.af_b_w^2) * (rho_0 * M_0 * c_0 * ac.af_S_w / (mu_0 * ac.af_b_w))^(-0.2)

    # Noise power
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 4
    Pi_star_les1 = 4.464e-5 * M_0^5 * delta_w_star  # Slat noise
    Pi_star_les2 = 4.464e-5 * M_0^5 * delta_w_star  # Added trailing edge noise
    
    # Determine the directivity function
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 8
    D_les = 4 * cos(phi * π / 180.)^2 * cos(theta / 2 * π / 180.)^2
    
    # Determine spectral distribution function
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 10-12-13
    S_les = freq * delta_w_star * ac.af_b_w / (M_0 * c_0) * (1 - M_0 * cos(theta * π / 180.))
    
    F_les1 = 0.613 * (10 * S_les).^4 .* ((10. * S_les).^1.5 .+ 0.5).^(-4)
    F_les2 = 0.613 * (2.19 * S_les).^4 .* ((2.19 * S_les).^1.5 .+ 0.5).^(-4)
    
    # Calculate msap
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 1
    r_s_star_af = settings.r_0 / ac.af_b_w
    msap_les = 1 / (4 * π * r_s_star_af^2) / (1 - M_0 * cos(theta * π / 180.))^4 * (Pi_star_les1 * D_les * F_les1 + Pi_star_les2 * D_les * F_les2)

    return msap_les
end
function trailing_edge_flap(settings::PyObject, ac::PyObject, freq::Array{Float64, 1}, M_0, c_0, theta, phi, theta_flaps)

    ### ---------------- Flap noise ----------------
    # Calculate noise power
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 14-15
    if ac.af_s < 3
        Pi_star_tef = 2.787e-4 * M_0^6 * ac.af_S_f / ac.af_b_w^2 * sin(theta_flaps * π / 180.)^2
    elseif ac.af_s == 3
        Pi_star_tef = 3.509e-4 * M_0^6 * ac.af_S_f / ac.af_b_w^2 * sin(theta_flaps * π / 180.)^2
    end
        
    # Calculation of the directivity function
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 16
    D_tef = 3 * (sin(theta_flaps * π / 180.) * cos(theta * π / 180.) + cos(theta_flaps * π / 180.) * sin(theta * π / 180.) * cos(phi * π / 180.))^2
    # Strouhal number
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 19
    S_tef = freq * ac.af_S_f / (M_0 * ac.af_b_f * c_0) * (1 - M_0 * cos(theta * π / 180.))
    
    # Calculation of the spectral function
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 17-18
    if ac.af_s < 3
        F_tef = zeros(eltype(S_tef), (settings.N_f, ))
        for i in range(1, settings.N_f, step=1)
            if S_tef[i] .< 2.
                F_tef[i] = 0.0480 * S_tef[i]
            elseif 2. .< S_tef[i] .< 20.
                F_tef[i] = 0.1406 * S_tef[i].^(-0.55)
            else
                F_tef[i] = 216.49 * S_tef[i].^(-3)
            end
        end
    elseif ac.af_s == 3
        F_tef = zeros(eltype(S_tef), (settings.N_f, ))
        for i in range(1, settings.N_f, step=1)
            if S_tef[i] .< 2.
                F_tef[i] = 0.0257 * S_tef[i]
            elseif 2. .< S_tef[i] .< 20.
                F_tef[i] = 0.0536 * S_tef[i].^(-0.0625)
            else
                F_tef[i] = 17078 * S_tef[i].^(-3)
            end
        end
    end
        
    # Calculate msap
    # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 1
    r_s_star_af = settings.r_0 / ac.af_b_w
    msap_tef = 1. / (4 * π * r_s_star_af^2) / (1 - M_0 * cos(theta * π / 180.))^4 * (Pi_star_tef * D_tef * F_tef)

    return msap_tef
end
function landing_gear(settings::PyObject, ac::PyObject, freq::Array{Float64, 1}, M_0, c_0, theta, phi, I_landing_gear)

    ### ---------------- Landing-gear noise ----------------
    if I_landing_gear == 1
        # Calculate nose-gear noise
        # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 29
        S_ng = freq * ac.af_d_ng / (M_0 * c_0) * (1 - M_0 * cos(theta * π / 180.))
        
        # Calculate noise power and spectral distribution function
        # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 20-21-22-25-26-27-28
        if ac.af_n_ng == 1 || ac.af_n_ng == 2
            Pi_star_ng_w = 4.349e-4 * M_0^6 * ac.af_n_ng * (ac.af_d_ng / ac.af_b_w)^2
            Pi_star_ng_s = 2.753e-4 * M_0^6 * (ac.af_d_ng / ac.af_b_w)^2 * (ac.af_l_ng / ac.af_d_ng)
            F_ng_w = 13.59 * S_ng.^2 .* (12.5 .+ S_ng.^2).^(-2.25)
            F_ng_s = 5.32 * S_ng.^2 .* (30 .+ S_ng.^8).^(-1)
        elseif ac.af_n_ng == 4
            Pi_star_ng_w = 3.414 - 4 * M_0^6 * ac.af_n_ng * (ac.af_d_ng / ac.af_b_w)^2
            Pi_star_ng_s = 2.753e-4 * M_0^6 * (ac.af_d_ng / ac.af_b_w)^2 * (ac.af_l_ng / ac.af_d_ng)
            F_ng_w = 0.0577 * S_ng.^2 .* (1 .+ 0.25 * S_ng.^2).^(-1.5)
            F_ng_s = 1.28 * S_ng.^3 .* (1.06 .+ S_ng.^2).^(-3)
        end
        
        # Calculate main-gear noise
        # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 29
        S_mg = freq * ac.af_d_mg / (M_0 * c_0) * (1 - M_0 * cos(theta * π / 180.))
        # Calculate noise power and spectral distribution function
        # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 20-21-22-25-26-27-28
        if ac.af_n_mg == 1 || ac.af_n_mg == 2
            Pi_star_mg_w = 4.349e-4 * M_0^6 * ac.af_n_mg * (ac.af_d_mg / ac.af_b_w)^2
            Pi_star_mg_s = 2.753e-4 * M_0^6 * (ac.af_d_mg / ac.af_b_w)^2 * (ac.af_l_ng / ac.af_d_mg)
            F_ng_w = 13.59 * S_mg.^2 .* (12.5 .+ S_mg.^2).^(-2.25)
            F_ng_s = 5.32 * S_mg.^2 .* (30 .+ S_mg.^8).^(-1)
        elseif ac.af_n_mg == 4
            Pi_star_mg_w = 3.414e-4 * M_0^6 * ac.af_n_mg * (ac.af_d_mg / ac.af_b_w)^2
            Pi_star_mg_s = 2.753e-4 * M_0^6 * (ac.af_d_mg / ac.af_b_w)^2 * (ac.af_l_ng / ac.af_d_mg)
            F_mg_w = 0.0577 * S_mg.^2 .* (1 .+ 0.25 * S_mg.^2).^(-1.5)
            F_mg_s = 1.28 * S_mg.^3 .* (1.06 .+ S_mg.^2).^(-3)
        end
        
        # Directivity function
        # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 23-24
        D_w = 1.5 * sin(theta * π / 180.)^2
        D_s = 3 * sin(theta * π / 180.)^2 * sin(phi * π / 180.)^2
        # Calculate msap
        # Source: Zorumski report 1982 part 2. Chapter 8.8 Equation 1
        # If landing gear is down
        r_s_star_af = settings.r_0 / ac.af_b_w
        msap_lg = 1 / (4 * π * r_s_star_af^2) / (1 - M_0 * cos(theta * π / 180.))^4 * (
                              ac.af_N_ng * (Pi_star_ng_w * F_ng_w * D_w + Pi_star_ng_s * F_ng_s * D_s) +
                              ac.af_N_mg * (Pi_star_mg_w * F_mg_w * D_w + Pi_star_mg_s * F_mg_s * D_s))

    # If landing gear is up
    else
        msap_lg = zeros(eltype(I_landing_gear), 1)
    end

    return msap_lg
end

function airframe(settings::PyObject, data::PyObject, ac::PyObject, n_t::Int64, M_0, mu_0, c_0, rho_0, theta, phi, theta_flaps, I_landing_gear)

    # Initialize solution
    T = eltype(theta_flaps)
    msap_af = zeros(T, (n_t, settings.N_f))
            
    for i in range(1, n_t, step=1)

        # Airframe noise only when aircraft is moving
        if M_0[i] != 0.

            # Apply HSR-era airframe suppression/calibration levels
            # Source: validation noise assessment data set of NASA STCA (Berton et al., 2019)
            if settings.hsr_calibration
                # Suppression data
                data_angles = data.supp_af_angles
                data_freq = data.supp_af_freq
                data_supp = data.supp_af
                f_supp = LinearInterpolation((data_freq, data_angles), data_supp)
                supp = f_supp.(data.f, theta[i]*ones(T, (settings.N_f, )))
            else
                supp = ones(T, (settings.N_f, ))
            end

            # Add airframe noise components
            msap_j = zeros(T, (settings.N_f, ))
            if "wing" in ac.comp_lst
                msap_w = trailing_edge_wing(settings, ac, data.f, M_0[i], c_0[i], rho_0[i], mu_0[i], theta[i], phi[i])
                msap_j = msap_j .+ msap_w .* supp
            end
            if "tail_v" in ac.comp_lst
                msap_v = trailing_edge_vertical_tail(settings, ac, data.f, M_0[i], c_0[i], rho_0[i], mu_0[i], theta[i], phi[i])
                msap_j = msap_j .+ msap_v .* supp
            end
            if "tail_h" in ac.comp_lst
                msap_h = trailing_edge_horizontal_tail(settings, ac, data.f, M_0[i], c_0[i], rho_0[i], mu_0[i], theta[i], phi[i])
                msap_j = msap_j .+ msap_h .* supp
            end
            if "les" in ac.comp_lst
                msap_les = leading_edge_slat(settings, ac, data.f, M_0[i], c_0[i], rho_0[i], mu_0[i], theta[i], phi[i])
                msap_j = msap_j .+ msap_les .* supp
            end
            if "tef" in ac.comp_lst
                msap_tef = trailing_edge_flap(settings, ac, data.f, M_0[i], c_0[i], theta[i], phi[i], theta_flaps[i])
                msap_j = msap_j .+ msap_tef .* supp
            end
            if "lg" in ac.comp_lst
                msap_lg = landing_gear(settings, ac, data.f, M_0[i], c_0[i], theta[i], phi[i], I_landing_gear[i])
                msap_j = msap_j .+ msap_lg .* supp
            end

            # Normalize msap by reference pressure
            msap_af[i,:] = msap_j/settings.p_ref^2

        else
            msap_af[i,:] =  1e-99 * ones(T, (settings.N_f, ))
        end
    end

    return msap_af
end