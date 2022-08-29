//
//  ViewController.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-25.
//

import UIKit

final class RandomCountryViewController: UIViewController {

    @IBOutlet var stepOneLabel: UILabel!
    @IBOutlet var stepTwoLabel: UILabel!
    @IBOutlet var stepThreeLabel: UILabel!
    @IBOutlet var gameButton: UIButton!

    private lazy var factoriesContainer = FactoriesContainer()
    private lazy var dataLoader = factoriesContainer.makeDataLoader()
    private lazy var viewModel = RandomCountryViewModel(loader: CountriesLoader(
        dataLoader: self.dataLoader,
        graphBuilder: factoriesContainer.makeGraphBuilder()))

    override func viewDidLoad() {
        super.viewDidLoad()

        stepOneLabel.text = Strings.GamePrep.stepOne.rawValue
        stepTwoLabel.text = Strings.GamePrep.stepTwo.rawValue
        stepThreeLabel.text = Strings.GamePrep.stepThree.rawValue

        loadCountries()
    }

    @IBAction func gameButtonTap() {
        switch viewModel.state {
        case .loaded:
            do {
                let countryViewModel = try viewModel.getRandomCountryViewModel(with: factoriesContainer.makeImageLoader(dataLoader: self.dataLoader))
                performSegue(withIdentifier: "ShowCountry", sender: countryViewModel)
            } catch {
                refreshButton()
                showError(with: Strings.GamePrep.alertMessageNoCountry.rawValue)
            }
        case .error:
            loadCountries()
        case .initial, .loading:
            refreshButton()
        }
    }

    // MARK: - Private

    private func loadCountries() {
        self.refreshButton()
        Task { @MainActor in
            do {
                try await viewModel.loadCountries()
            } catch {
                self.showError(with: Strings.GamePrep.alertMessage.rawValue)
            }
            self.refreshButton()
        }
    }

    private func refreshButton() {
        let buttonOptions = self.viewModel.gameButtonOptions()
        gameButton.setTitle(buttonOptions.title, for: .normal)
        gameButton.isEnabled = buttonOptions.isEnabled
    }

    private func showError(with message: String) {
        let alert = UIAlertController(title: Strings.GamePrep.alertTitle.rawValue, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.GamePrep.cancelButton.rawValue, style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: Strings.GamePrep.okButton.rawValue, style: .default, handler: { [weak self] _ in
            self?.loadCountries()
        }))
        self.present(alert, animated: true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewModel = sender as? CountryViewModel, segue.identifier == "ShowCountry" {
            (segue.destination as? CountryViewController)?.countryViewModel = viewModel
        }
    }
}

