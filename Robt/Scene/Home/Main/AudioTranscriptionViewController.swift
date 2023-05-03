//
//  AudioTranscriptionViewController.swift
//  Robt
//
//  Created by hong on 2023/05/02.
//

import Combine
import UIKit

final class AudioTranscriptionViewController: UIViewController {

    private lazy var audioTitleView = PaddingUILabel(left: 20, right: 20).then {
        $0.textColor = .gray
        $0.font = Font.regular(size: 18)
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.purple.cgColor
        $0.clipsToBounds = true
        $0.text = "please select audio file"
    }

    private lazy var audioSelectButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.setTitle("선택", for: .normal)
        $0.setTitleColor(.OFFFFFF, for: .normal)
        $0.setTitleColor(.OFFFFFF.withAlphaComponent(0.6), for: .highlighted)
        $0.setBackgroundColor(.O000000, for: .normal)
        $0.setBackgroundColor(.O000000.withAlphaComponent(0.6), for: .highlighted)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.titleLabel?.font = Font.bold(size: 18)
    }

    private lazy var transcriptionContainerView = UIScrollView()
    private lazy var transcriptionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 20
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
    }

    private lazy var activityIndicator: UIActivityIndicatorView = .init(style: .large)

    private lazy var transcriptionView = UILabel().then {
        $0.textColor = .black
        $0.font = Font.medium(size: 16)
        $0.numberOfLines = 0
        $0.text = "아직 추출된 음성이 없습니다."
    }

    private lazy var documentPicker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)

    private let viewModel: AudioTrnascriptionViewModel
    private var cancellabels: Set<AnyCancellable> = .init()
    private var input: PassthroughSubject<AudioTrnascriptionViewModel.Input, Never> = .init()

    init(viewModel: AudioTrnascriptionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }

    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case let .audioFileUploaded(transcription):
                DispatchQueue.main.async {
                    self.indicatorBlock(false)
                    self.transcriptionView.text = transcription
                }
            case .audioFileUploadFailed:
                self.indicatorBlock(false)
                self.presentOKAlert(title: "오디오 추출에 실패하였습니다", message: "재시도 해주세요")
            case .audioSelectButtonDidTap:
                self.present(self.documentPicker, animated: true)
            }
        }
        .store(in: &cancellabels)
        audioSelectButton.tapPublisher.sink { [weak self] _ in
            self?.input.send(.audioSelectButtonTapped)
        }
        .store(in: &cancellabels)
    }
}

extension AudioTranscriptionViewController {
    private func configure() {
        title = "오디오 추출"
        view.backgroundColor = .white
        tabBarController?.setTabBarVisible(visible: false, duration: 0, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        [audioTitleView, audioSelectButton, transcriptionContainerView, activityIndicator].forEach {
            view.addSubview($0)
        }
        transcriptionContainerView.addSubview(transcriptionStackView)
        transcriptionStackView.addArrangedSubview(transcriptionView)
        documentPicker.delegate = self
        layoutConfigure()
        inidicatorConfigure()
    }

    private func layoutConfigure() {
        audioTitleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.leading.equalToSuperview().inset(50)
            make.trailing.equalToSuperview().inset(120)
            make.height.equalTo(50)
        }
        audioSelectButton.snp.makeConstraints { make in
            make.top.equalTo(audioTitleView.snp.top)
            make.leading.equalTo(audioTitleView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(50)
            make.height.equalTo(audioTitleView.snp.height)
        }
        transcriptionContainerView.snp.makeConstraints { make in
            make.top.equalTo(audioTitleView.snp.bottom).offset(50)
            make.horizontalEdges.equalToSuperview().inset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
        transcriptionStackView.snp.makeConstraints { make in
            make.width.edges.equalToSuperview()
        }
    }

    private func inidicatorConfigure() {
        activityIndicator.center = view.center
    }

    private func indicatorBlock(_ block: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if block {
                self.view.isUserInteractionEnabled = false
                self.view.alpha = 0.3
                self.activityIndicator.startAnimating()
            } else {
                self.view.isUserInteractionEnabled = true
                self.view.alpha = 1.0
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

extension AudioTranscriptionViewController: UIDocumentPickerDelegate {
    func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = urls[0]
        audioTitleView.text = url.lastPathComponent
        indicatorBlock(true)
        input.send(.audioFileUpload(url))
    }

    func documentPickerWasCancelled(_: UIDocumentPickerViewController) {
        print("cancelled picker")
    }
}
