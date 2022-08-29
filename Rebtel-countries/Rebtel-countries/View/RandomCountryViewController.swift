//
//  ViewController.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-25.
//

import UIKit

class RandomCountryViewController: UIViewController {

    @IBOutlet var stepOneLabel: UILabel!
    @IBOutlet var stepTwoLabel: UILabel!
    @IBOutlet var stepThreeLabel: UILabel!
    @IBOutlet var gameButton: UIButton!

    private lazy var dataLoader = DependencyContainer.shared.makeDataLoader()
    private lazy var viewModel = RandomCountryViewModel(loader: CountriesLoader(
        dataLoader: self.dataLoader,
        graphBuilder: DependencyContainer.shared.makeGraphBuilder()))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stepOneLabel.text = Strings.GamePrep.stepOne.rawValue
        stepTwoLabel.text = Strings.GamePrep.stepTwo.rawValue
        stepThreeLabel.text = Strings.GamePrep.stepThree.rawValue

        self.loadCountries()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    private func loadCountries() {
        Task { @MainActor in
            do {
                gameButton.setTitle(Strings.GamePrep.buttonTitleLoading.rawValue, for: .normal)
                gameButton.isEnabled = false
                try await viewModel.loadCountries()
                gameButton.isEnabled = true
                gameButton.setTitle(Strings.GamePrep.buttonTitleGo.rawValue, for: .normal)
            } catch {
                print(error)
                self.showError(with: Strings.GamePrep.alertMessage.rawValue)
            }
        }
    }

    private func showError(with message: String) {
        let alert = UIAlertController(title: Strings.GamePrep.alertTitle.rawValue, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.GamePrep.cancelButton.rawValue, style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: Strings.GamePrep.okButton.rawValue, style: .default, handler: { [weak self] _ in
            self?.loadCountries()
        }))
        gameButton.setTitle(Strings.GamePrep.buttonTitleReload.rawValue, for: .normal)
        gameButton.isEnabled = true
        self.present(alert, animated: true)
    }

    @IBAction func gameButtonTap() {
        if viewModel.isReady {
            do {
                let countryViewModel = try viewModel.selectRandom(with: DependencyContainer.shared.makeImageLoader(dataLoader: self.dataLoader))
                performSegue(withIdentifier: "ShowCountry", sender: countryViewModel)
            } catch {
                showError(with: Strings.GamePrep.alertMessageNoCountry.rawValue)
            }

        } else {
            loadCountries()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewModel = sender as? CountryViewModel, segue.identifier == "ShowCountry" {
            (segue.destination as? CountryViewController)?.countryViewModel = viewModel
        }
    }
}

